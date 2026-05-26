functions --copy fish_prompt __fish_prompt_default

function fish_prompt --description 'Write out the prompt'
    __fish_prompt_default | string replace --regex "([>#] )\$" "\n\$1"
end
