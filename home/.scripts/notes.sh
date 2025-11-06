#!/bin/bash
NOTES_DIR="${NOTES_DIR:-$HOME/notes}"
NOTES_VIEWER="${NOTES_VIEWER:-glow}"

command="$1"
filepath="$2"

require_filepath() {
    if [ -z "$filepath" ]; then
        echo "Usage: $0 $command <filepath>"
        exit 1
    fi
}

case "$command" in
    open)
        require_filepath

        # get full path
        full_path="$NOTES_DIR/$filepath"

        # create dir if doesn't exist
        dir=$(dirname "$full_path")
        mkdir -p "$dir"

        echo "Editing $full_path"

        # create & open file
        ${EDITOR:-vi} "$full_path"
        ;;

    view)
        if [ -z "$filepath" ]; then
            # search & open
            selected=$(find "$NOTES_DIR" -not -path '*/.*' -type f | sed "s|^$NOTES_DIR/||" | fzf)

            if [ -n "$selected" ]; then
                ${NOTES_VIEWER} "$NOTES_DIR/$selected"
            fi
        else
            # view by filepath

            # get full path
            full_path="$NOTES_DIR/$filepath"

            # ensure exists
            if [ ! -f "$full_path" ]; then
                echo "Error: Note '$filepath' does not exist"
                exit 1
            fi

            echo "Viewing $full_path"

            # display with glow or fallback to cat
            if command -v $NOTES_VIEWER &> /dev/null; then
                $NOTES_VIEWER "$full_path"
            else
                cat "$full_path" | more
            fi
        fi
        ;;

    list)
        echo $NOTES_DIR
        # show tree of all notes
        if command -v tree &> /dev/null; then
            tree "$NOTES_DIR"
        else
            find "$NOTES_DIR" -type f -o -type d | sort | sed "s|$NOTES_DIR||" | sed 's|[^/]*\/|  |g'
        fi
        ;;

    *)
        # default fuzzy search - find and select a note
        selected=$(find "$NOTES_DIR" -not -path '*/.*' -type f | sed "s|^$NOTES_DIR/||" | fzf)

        if [ -n "$selected" ]; then
            ${EDITOR:-vi} "$NOTES_DIR/$selected"
        fi
        ;;
esac
