#!/bin/bash

# shell script to support running whisper via CUDA
# uses medium model: https://github.com/openai/whisper?tab=readme-ov-file#available-models-and-languages
# requires ~ 5GB of VRAM

# verbose flag
# default flag to false
VERBOSE=False

# check for true
for arg in "$@"; do
    if [[ "$arg" == "-v" || "$arg" == "--verbose" ]]; then
        VERBOSE=True
        echo "Verbose mode enabled. Whisper output will be displayed."
        echo
    fi
done

# prompt user for directory
while true; do
    read -r -p "Enter the directory path containing the media file: " DIR

    # convert windows backslashes to forward slashes
    DIR="${DIR//\\//}"

    # check for directory
    if [[ ! -d "$DIR" ]]; then
        echo "Error: Directory not found: $DIR"
        continue
    fi
    break
done

echo
echo "Directory detected: $DIR"
echo

# Prompt user for media file in that directory

while true; do
    read -r -p "Enter the media file name (spaces allowed) in specified directory: " FILE_NAME
    FILE="$DIR/$FILE_NAME"

    # check for file presence
    if [[ ! -f "$FILE" ]]; then
        echo "Error: File not found: $FILE"
        continue
    fi
    break
done

BASENAME=$(basename "$FILE")
NAME="${BASENAME%.*}"

echo
echo "File detected: $FILE"
echo

# language selection (English / Czech)

LANGUAGES=("English" "Czech")

echo "Select the language of the media file:"
echo "1) English"
echo "2) Czech"

while true; do
    read -r -p "Enter number: " CHOICE
    if [[ "$CHOICE" == "1" || "$CHOICE" == "2" ]]; then
        LANGUAGE="${LANGUAGES[$((CHOICE-1))]}"
        break
    else
        echo "Invalid option. Enter 1 or 2."
    fi
done

echo
echo "Media language selected: $LANGUAGE"
echo


# task selection (transcribe / translate)

echo "Select task:"
echo "1) Transcribe (same language)"
echo "2) Translate (to English)"

while true; do
    read -r -p "Enter number: " TASK_CHOICE
    case "$TASK_CHOICE" in
        1) TASK="transcribe" ;;
        2) TASK="translate" ;;
        *) echo "Invalid option. Enter 1 or 2."; continue ;;
    esac
    break
done

echo
echo "Task selected: $TASK"
echo

# build Whisper command
# runs CUDA only!

WHISPER_CMD=(whisper "$FILE" \
    --model medium \
    --device cuda \
    --output_dir "$DIR" \
    --output_format srt \
    --word_timestamps True \
    --max_line_width 80 \
    --max_line_count 2 \
    --task "$TASK" \
    --language "$LANGUAGE" \
    --verbose "$VERBOSE")

# run Whisper

echo "Running Whisper..."
echo

if [ "$VERBOSE" = True ]; then
    # verbose: show progress live
    if "${WHISPER_CMD[@]}"; then
        WHISPER_SUCCESS=true
    else
        WHISPER_SUCCESS=false
    fi
else
    # quiet: fully suppress output
    if "${WHISPER_CMD[@]}" &> /dev/null; then
        WHISPER_SUCCESS=true
    else
        WHISPER_SUCCESS=false
    fi
fi

# handle success/failure and rename

if [ "$WHISPER_SUCCESS" = true ]; then

    # renaming
    EXT="srt"
    ORIG_OUTPUT="$DIR/${BASENAME%.*}.${EXT}"
    NEW_OUTPUT="$DIR/${NAME}_${LANGUAGE}.srt"

    if [[ -f "$ORIG_OUTPUT" ]]; then
        mv "$ORIG_OUTPUT" "$NEW_OUTPUT"
        echo
        echo "Done! Output file created: $NEW_OUTPUT"
    else
        echo
        echo "Warning: Expected output file '$ORIG_OUTPUT' not found."
    fi
else
    echo
    echo "Whisper failed. Check the input file, model, or language."
    exit 1
fi
