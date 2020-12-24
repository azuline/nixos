function upload_image
	set response (curl -X POST -H "Content-Type:multipart/form-data" -H"Authorization:Token $SAFFRON_TOKEN" -F "upload=@$argv[1]" https://u.sunsetglow.net/upload)
	set image_url (echo $response | jq -r '.image_url')
	echo
	echo $image_url
	echo $image_url | wl-copy
end

alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias info='info --vi-keys'  # Emacs and cheese not allowed.
alias gname='git config user.name; git config user.email'
alias gupd='git add .; git commit -m update'
alias gitlines='git ls-files | xargs -d "\n" wc -l'
alias gst='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
alias gr='cd (git rev-parse --show-toplevel)'

alias rscp='rsync -ah --progress'

alias w='cd ~/notes; vim index.md'

alias is='upload_image (/bin/ls -d1t ~/images/scrots/* | head -n1 | tr -d \"\\n\")'
alias iu='upload_image'
alias bs='bubblegum upload (/bin/ls -d1t ~/images/scrots/* | head -n1 | tr -d \"\\n\")'
alias bu='bubblegum upload'
