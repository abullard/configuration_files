# MacOS only
function guid {
	uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n' | pbcopy
}
