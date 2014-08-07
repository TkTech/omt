# Use the latest ubuntu base
FROM ubuntu

# Make sure all packages are up to date.
# RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Essentials for setup
RUN apt-get install -y zsh git-core wget
# Nice-to-have(s)
RUN apt-get install -y vim

# Add a trusted group who can use chsh without requiring a password,
# which breaks the oh-my-zsh install.
RUN echo "auth sufficient pam_wheel.so trust group=chsh" | cat - /etc/pam.d/chsh > _tmp && mv _tmp /etc/pam.d/chsh
RUN groupadd chsh

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

# Done!
