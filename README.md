```ascii                                                                                                                                                                                                                                                 
                                                                     
       ████ ██████           █████      ██                     
      ███████████             █████                             
      █████████ ███████████████████ ███   ███████████   
     █████████  ███    █████████████ █████ ██████████████   
    █████████ ██████████ █████████ █████ █████ ████ █████   
  ███████████ ███    ███ █████████ █████ █████ ████ █████  
 ██████  █████████████████████ ████ █████ █████ ████ ██████ 

```                                               
			                                                                

# dotfiles

This repo contains my dotfile configurations. This allows for a consistent experience across multiple computers.

I manage these configuration files using [GNU Stow](https://www.gnu.org/software/stow/). This allows me to set up symlinks for all dotfiles using a single command:

```bash
    stow .
```

## Installation

To clone this repo and its submodules, run the following command:

```bash
    git clone --recurse-submodules https://github.com/jacob-lineberry/dotfiles.git
```
