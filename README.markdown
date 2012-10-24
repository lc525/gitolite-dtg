# gitolite-dtg #
Digital Technology Group, University of Cambridge
Forked from [wingrunr21/gitolite](https://github.com/wingrunr21/gitolite)

This gem provides a Ruby read-only interface to the [gitolite](https://github.com/sitaramc/gitolite) git backend system 
(by parsing the configuration file found in the bare gitolite-admin repository).  It aims to enable an application to query
gitolite repository permissions based on data written in the gitolite-admin repository. 

This fork is designed to work as part of a Ruby authorization mechanism to gitolite repositories (see the related
gollum-dtg project for an example of how we use it).

Please see the upstream project for a Ruby API aiming to provide all management functionality (read and write) that is 
available via the gitolite-admin repository (like SSH keys, adding/removing repositories, etc). 


## Requirements ##
* Ruby 1.8.x or 1.9.x
* a working [gitolite](https://github.com/sitaramc/gitolite) installation
* appropiate read permisions for the <tt>gitolite-admin</tt> bare repository

## Installation ##

    gem install gitolite-dtg

## Usage ##

### Load a gitolite-admin repo ###

    require 'gitolite-dtg'
    ga_repo = Gitolite::GitoliteAdmin.new("/path/to/gitolite/repos/gitolite-admin.git")

This method can only be called on an existing gitolite-admin repo.

## Caveats ##
### Windows compatibility ###
The grit gem (which is used for under-the-hood git operations) does not currently support Windows.  Until it does, gitolite will be unable to support Windows.

### Group Ordering ###
When the gitolite backend parses the config file, it does so in one pass.  Because of this, groups that are modified after being used do not see those changes reflected in previous uses.

For example:

    @groupa = bob joe sue
    @groupb = jim @groupa
    @groupa = sam

Group b will contain the users <tt>jim, bob, joe, and sue</tt>

The gitolite gem, on the other hand, will <em>always</em> output groups so that all modifications are represented before it is ever used.  For the above example, group b will be output with the following users: <tt>jim, bob, joe, sue, and sam</tt>.  The groups in the config file will look like this:

    @groupa = bob joe sue sam
    @groupb = jim @groupa


### Contributors ###
* Stafford Brunk - [wingrunr21](https://github.com/wingrunr21) (original developer of the API)
* Alexander Simonov - [simonoff](https://github.com/simonoff)
