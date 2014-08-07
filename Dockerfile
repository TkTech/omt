# Use the latest ubuntu base
FROM ubuntu

# Make sure all packages are up to date.
# RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Essentials for setup
RUN apt-get install -y zsh git-core wget python python-pip
# Nice-to-have(s)
RUN apt-get install -y vim

# Add a trusted group who can use chsh without requiring a password,
# which breaks the oh-my-zsh install.
RUN echo "auth sufficient pam_wheel.so trust group=chsh" | cat - /etc/pam.d/chsh > _tmp && mv _tmp /etc/pam.d/chsh
RUN groupadd chsh

# Pull down and install the oh-my-themes tool
WORKDIR /root
RUN git clone https://github.com/TkTech/omt.git
WORKDIR /root/omt
RUN python setup.py install

# Create our runtime "omt" user
RUN adduser omt --gecos "omt,,," --disabled-password 
# Add our new user to the group that doesn't require a password for chsh
RUN usermod -a -G chsh omt

# Switch to the omt user
USER omt
# Set the HOME variable, since by default the base image hard-codes it to /
ENV HOME /home/omt
WORKDIR /home/omt

# Run the oh-my-zsh install
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
# Stop the default theme from being loaded.
RUN sed -i 's/ZSH_THEME/#ZSH_THEME/g' /home/omt/.zshrc
# Source the theme we'll share with docker on each run.
RUN echo "source /mnt/themes/theme" >> /home/omt/.zshrc

# Done!
