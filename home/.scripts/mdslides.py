#!/usr/bin/env python3
"""mdslides - View markdown files as terminal slide presentations."""

import sys
import os
import re
import tty
import termios
import signal

# --- ANSI escape codes ---
RESET = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
ITALIC = "\033[3m"
UNDERLINE = "\033[4m"
STRIKETHROUGH = "\033[9m"

DARK_BLUE_BG = "\033[48;5;17m"
LIGHT_BLUE_BG = "\033[48;5;24m"
LIGHT_BLUE_FG = "\033[38;5;117m"
CYAN_FG = "\033[38;5;80m"
TEAL_FG = "\033[38;5;73m"
RED_FG = "\033[38;5;196m"
DARK_GRAY_BG = "\033[48;5;236m"
LIGHT_GRAY_FG = "\033[38;5;250m"
WHITE_FG = "\033[38;5;255m"
YELLOW_FG = "\033[38;5;220m"
GREEN_FG = "\033[38;5;114m"

GLOBAL_PAD = "  "
GLOBAL_RPAD = "  "
# Marker prefix for lines that handle their own padding (e.g. code blocks)
RAW_MARKER = "\x00"


def strip_ansi(text):
    return re.sub(r"\033\[[0-9;]*m", "", text)


def visible_len(text):
    return len(strip_ansi(text))


def center_line(text, cols):
    """Center a line horizontally based on its visible length."""
    vlen = visible_len(text)
    if vlen >= cols:
        return text
    pad = (cols - vlen) // 2
    return " " * pad + text


def render_inline(text):
    """Process inline markdown: code spans, bold, italic, strikethrough, links."""
    # Inline code first — protect from other formatting
    result = []
    pos = 0
    while pos < len(text):
        if text[pos] == "`":
            end = text.find("`", pos + 1)
            if end != -1:
                code = text[pos + 1 : end]
                result.append(f"{RED_FG}{DARK_GRAY_BG} {code} {RESET}")
                pos = end + 1
                continue
        result.append(text[pos])
        pos += 1
    text = "".join(result)

    # Bold + italic
    text = re.sub(r"\*\*\*(.+?)\*\*\*", f"{BOLD}{ITALIC}\\1{RESET}", text)
    # Bold
    text = re.sub(r"\*\*(.+?)\*\*", f"{BOLD}\\1{RESET}", text)
    text = re.sub(r"__(.+?)__", f"{BOLD}\\1{RESET}", text)
    # Italic
    text = re.sub(r"\*(.+?)\*", f"{ITALIC}\\1{RESET}", text)
    text = re.sub(r"(?<!\w)_(.+?)_(?!\w)", f"{ITALIC}\\1{RESET}", text)
    # Strikethrough
    text = re.sub(r"~~(.+?)~~", f"{STRIKETHROUGH}\\1{RESET}", text)
    # Links [text](url) → underlined url
    text = re.sub(r"\[([^\]]*)\]\(([^)]+)\)", f"{UNDERLINE}\\2{RESET}", text)

    return text


# --- Block renderers ---
# Note: renderers do NOT add left padding — that's applied globally in render_slide.


def render_h1(text, cols):
    text = re.sub(r"^#\s+", "", text).strip()
    lines = [""] * 6  # vertical padding
    padded = f" {text} "
    lines.append(f"{DARK_BLUE_BG}{BOLD}{WHITE_FG}{padded}{RESET}")
    lines.append("")
    return lines


def render_h2(text, cols):
    text = re.sub(r"^##\s+", "", text).strip()
    padded = f" {text} "
    return [f"{LIGHT_BLUE_BG}{BOLD}{WHITE_FG}{padded}{RESET}", ""]


def render_h3(text):
    text = re.sub(r"^###\s+", "", text).strip()
    return [f"{LIGHT_BLUE_FG}{BOLD}{text}{RESET}", ""]


def render_h4(text):
    text = re.sub(r"^####\s+", "", text).strip()
    return [f"{CYAN_FG}{BOLD}{text}{RESET}", ""]


def render_h5(text):
    text = re.sub(r"^#####\s+", "", text).strip()
    return [f"{TEAL_FG}{text}{RESET}", ""]


def render_h6(text):
    text = re.sub(r"^######\s+", "", text).strip()
    return [f"{DIM}{TEAL_FG}{text}{RESET}", ""]


def render_code_block(code_lines, cols):
    lpad = len(GLOBAL_PAD)
    rpad = len(GLOBAL_RPAD)
    inner = 1  # 1 space inner padding
    rendered = []
    for line in code_lines:
        # bg spans full width; text is inset by margins + inner pad
        content = " " * inner + line
        fill = max(0, cols - lpad - rpad - len(content))
        rendered.append(
            RAW_MARKER
            + GLOBAL_PAD
            + f"{DARK_GRAY_BG}{LIGHT_GRAY_FG}{content}{' ' * fill}{RESET}"
            + GLOBAL_RPAD
        )
    return rendered


def render_table(table_lines, cols):
    rows = []
    for line in table_lines:
        line = line.strip()
        if line.startswith("|"):
            line = line[1:]
        if line.endswith("|"):
            line = line[:-1]
        cells = [c.strip() for c in line.split("|")]
        # Skip separator rows (---|---)
        if all(re.match(r"^:?-+:?$", c) for c in cells if c):
            continue
        rows.append(cells)

    if not rows:
        return [render_inline(l) for l in table_lines]

    num_cols = max(len(r) for r in rows)
    col_widths = [0] * num_cols
    for row in rows:
        for i, cell in enumerate(row):
            if i < num_cols:
                col_widths[i] = max(col_widths[i], len(cell))
    col_widths = [w + 2 for w in col_widths]  # padding

    rendered = []
    # Top border
    rendered.append("┌" + "┬".join("─" * w for w in col_widths) + "┐")

    for i, row in enumerate(rows):
        cells = []
        for j in range(num_cols):
            cell_text = row[j] if j < len(row) else ""
            cell_rendered = render_inline(cell_text)
            pad = col_widths[j] - visible_len(cell_rendered) - 1
            cells.append(f" {cell_rendered}{' ' * max(0, pad)}")
        line = "│" + "│".join(cells) + "│"
        if i == 0 and len(rows) > 1:
            rendered.append(f"{BOLD}{line}{RESET}")
            rendered.append(
                "├" + "┼".join("─" * w for w in col_widths) + "┤"
            )
        else:
            rendered.append(line)

    rendered.append("└" + "┴".join("─" * w for w in col_widths) + "┘")
    return rendered


def render_blockquote(bq_lines):
    rendered = []
    for line in bq_lines:
        text = re.sub(r"^>\s?", "", line)
        text = render_inline(text)
        rendered.append(f"{DIM}│ {text}{RESET}")
    return rendered


def render_list_item(line):
    # Checklist
    m = re.match(r"^(\s*)[-*+]\s+\[([xX ])\]\s+(.*)", line)
    if m:
        indent, check, text = m.group(1), m.group(2), render_inline(m.group(3))
        icon = f"{GREEN_FG}✔{RESET}" if check.lower() == "x" else "☐"
        return f"{indent}{icon} {text}"
    # Unordered
    m = re.match(r"^(\s*)[-*+]\s+(.*)", line)
    if m:
        indent, text = m.group(1), render_inline(m.group(2))
        depth = len(indent) // 2
        bullets = ["•", "◦", "▸", "▹"]
        return f"{indent}{YELLOW_FG}{bullets[depth % len(bullets)]}{RESET} {text}"
    # Ordered
    m = re.match(r"^(\s*)(\d+)[.)]\s+(.*)", line)
    if m:
        indent, num, text = m.group(1), m.group(2), render_inline(m.group(3))
        return f"{indent}{YELLOW_FG}{num}.{RESET} {text}"
    return None


def render_hr(cols):
    width = cols - len(GLOBAL_PAD) - len(GLOBAL_RPAD)
    return [f"{DIM}{'─' * max(0, width)}{RESET}"]


# --- Slide parsing & rendering ---


def parse_slides(content):
    """Split markdown into slides on every H1 or H2 boundary."""
    lines = content.split("\n")
    slides = []
    current = []

    for line in lines:
        if re.match(r"^#{1,2}(?!#)\s", line):
            if current:
                slides.append(current)
            current = [line]
        else:
            current.append(line)
    if current:
        slides.append(current)

    return slides


def render_slide(slide_lines, cols, rows, slide_num, total):
    output = []
    i = 0
    is_h1_slide = bool(slide_lines and re.match(r"^# (?!#)", slide_lines[0]))

    while i < len(slide_lines):
        line = slide_lines[i]

        # Headers
        if re.match(r"^# (?!#)", line):
            output.extend(render_h1(line, cols))
            i += 1
            continue
        if re.match(r"^## (?!#)", line):
            output.extend(render_h2(line, cols))
            i += 1
            continue
        if re.match(r"^### (?!#)", line):
            output.extend(render_h3(line))
            i += 1
            continue
        if re.match(r"^#### (?!#)", line):
            output.extend(render_h4(line))
            i += 1
            continue
        if re.match(r"^##### (?!#)", line):
            output.extend(render_h5(line))
            i += 1
            continue
        if re.match(r"^###### ", line):
            output.extend(render_h6(line))
            i += 1
            continue

        # Fenced code block
        if line.strip().startswith("```"):
            code_lines = []
            i += 1
            while i < len(slide_lines) and not slide_lines[i].strip().startswith("```"):
                code_lines.append(slide_lines[i])
                i += 1
            i += 1  # skip closing fence
            output.extend(render_code_block(code_lines, cols))
            output.append("")
            continue

        # Table (two consecutive lines containing |)
        if "|" in line and i + 1 < len(slide_lines) and "|" in slide_lines[i + 1]:
            table = []
            while i < len(slide_lines) and "|" in slide_lines[i]:
                table.append(slide_lines[i])
                i += 1
            output.extend(render_table(table, cols))
            output.append("")
            continue

        # Blockquote
        if line.startswith(">"):
            bq = []
            while i < len(slide_lines) and slide_lines[i].startswith(">"):
                bq.append(slide_lines[i])
                i += 1
            output.extend(render_blockquote(bq))
            output.append("")
            continue

        # Horizontal rule
        if re.match(r"^\s*[-*_]{3,}\s*$", line):
            output.extend(render_hr(cols))
            i += 1
            continue

        # List items
        li = render_list_item(line)
        if li is not None:
            output.append(li)
            i += 1
            continue

        # Blank line
        if not line.strip():
            output.append("")
            i += 1
            continue

        # Regular text
        output.append(render_inline(line))
        i += 1

    # Apply global padding: 1 line top pad, 2 space left pad (or centering for H1)
    # Lines prefixed with RAW_MARKER already handle their own padding.
    padded = [""]  # 1 line vertical top pad
    for line in output:
        if line.startswith(RAW_MARKER):
            padded.append(line[len(RAW_MARKER):])
        elif not line.strip():
            padded.append("")
        elif is_h1_slide:
            padded.append(center_line(line, cols))
        else:
            padded.append(GLOBAL_PAD + line)
    output = padded

    # Pad to fill screen (reserve last line for counter)
    while len(output) < rows - 1:
        output.append("")

    # Slide counter bottom-right
    counter = f" {slide_num}/{total} "
    pad = max(0, cols - len(counter))
    output.append(f"{' ' * pad}{DIM}{counter}{RESET}")

    return output


# --- Terminal I/O ---


def get_key(fd):
    ch = os.read(fd, 1)
    if ch == b"\x1b":
        seq = os.read(fd, 2)
        if seq == b"[D":
            return "back"
        if seq == b"[C":
            return "forward"
        return "other"
    if ch in (b"q", b"Q"):
        return "quit"
    if ch in (b"p", b"P", b"b", b"B"):
        return "back"
    return "forward"


def main():
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} <file.md>")
        sys.exit(1)

    with open(sys.argv[1], "r") as f:
        content = f.read()

    slides = parse_slides(content)
    if not slides:
        print("No slides found.")
        sys.exit(1)

    total = len(slides)
    current = 0
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)

    try:
        tty.setraw(fd)
        sys.stdout.write("\033[?25l")  # hide cursor
        signal.signal(signal.SIGWINCH, lambda *_: None)

        while True:
            cols, rows = os.get_terminal_size()
            rendered = render_slide(slides[current], cols, rows, current + 1, total)
            sys.stdout.write("\033[2J\033[H")  # clear screen
            sys.stdout.write("\r\n".join(rendered[:rows]))
            sys.stdout.flush()

            key = get_key(fd)
            if key == "quit":
                break
            elif key == "back":
                current = max(0, current - 1)
            elif key == "forward":
                if current < total - 1:
                    current += 1
                else:
                    break
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        sys.stdout.write("\033[?25h")  # show cursor
        sys.stdout.write("\033[2J\033[H")  # clear screen
        sys.stdout.flush()
        print("Presentation ended.")


if __name__ == "__main__":
    main()
