Pivotal Tracker Git Hooks
=========================

Pivotal Tracker Git Hooks will automatically add the Pivotal Tracker ticket number to commit comments, based on the branch name. This is useful when using feature/topic branches, such as with [git flow](https://github.com/nvie/gitflow), and when [integrating Pivotal Tracker with GitHub](https://www.pivotaltracker.com/help/api?version=v3#github_hooks).

As-is, these hooks expect the branch name to have either a `feature/` or `hotfix/` prefix, followed by the numeric Pivotal Tracker ticket number, a hypen, then the a free form name or description. For example, `feature/123456-my-awesome-feature` or `hotfix/234567-my-awesome-hostfix`. See below for information about changing the hooks to use a different format.

A hook is provided for both `commit-msg` and `prepare-commit-msg`. The `commit-msg` hook is used when providing a message on the command-line: `git commit -m "…"`. The hook will take the Pivotal Tracker ticket number from the current branch and prepend it to the specified message. 

The `prepare-commit-msg` hook is used when no message is specified: `git commit`. In this case, git with open an editor in which to enter your commit message. The Pivotal Tracker ticket number will be pre-filled.


Requirements
------------

These hooks require Python 2.x. They were tested on Mac OS X 10.8 with Python 2.7, but should work on any Unix-like system with any Python 2.x version. They have not been tested with Python 3.x. If you run into problems, please file an issue and specify your operating system and Python version. Better still, fork and submit a pull request on Github.

A shell script, `apply.sh`, is included which requires bash. If for some reason you don't have bash installed, you could manually create the symbolic links or copy the hooks yourself.

Usage
-----
To apply these hooks to your local repository:


1. `git clone https://github.com/jimothyGator/pivotal-git-hooks`
2. `cd pivotal-git-hooks`
3. `./apply.sh /path/to/your/repository`

This creates symbolic links from your project's git hooks directory to the Pivotal Tracker Git Hooks, so if you make changes or update to a new version of Pivotal Tracker Git Hooks, these changes will automatically apply to all of your linked projects.

If `commit-msg` or `prepare-commit-msg` hooks already exist, the script by default will not replace them. To force it to replace existing scripts, use the `-f` option:

    ./apply.sh -f /path/to/your/repository

You may specify multiple repositories in a single command:

    ./apply.sh ~/projects/project1 ~/projects/project2
    
Then, create feature (or topic) branch, such as `feature/123456-my-cool-feature`. Use git as you normally would to stage and commit files. For example:

    git commit -m "making this a success of monumental proportions"   

The actually commit comment will be "[#123456] made this a success of monumental proportions".

If you specify the ticket number in the comment, preceded by a `#`, the hooks will not add the ticket number a second time. This allows you to use messages such as `[Finished #123456] made this a success of monumental proportions`, which tells Pivotal Tracker to automatically mark the story as complete. (See [SCM Post-Commit Message Syntax](https://www.pivotaltracker.com/help/api?version=v3#scm_post_commit_message_syntax) for more information). In this case, the original commit message will be used, unchanged.

You can also commit changes without specifying a commit message. Git will then open an editor to allow you to enter changes. The the message will be prepended with the ticket number: `[#123456]`. Add your message and save as you normally would when using git.

Vim Tip
-------
If you use vim as your editor, and commit without specifying a message, it's helpful to have vim automatically position the cursor after your commit message. You can do this by adding the following lines to your `~/.vimrc` file:

    :filetype on
    autocmd FileType gitcommit call cursor(1, 99)    

Then when committing, hit `a` and append your commit message after the Pivotal Tracker ticket number.

Using a Different Branch Name Format
------------------------------------

If your branch names use a different format that the default, you may edit the hook to provide a different pattern. The hooks expect branch names to resemble `feature/123456-my-awesome-feature` or `hotfix/234567-my-awesome-hostfix`, but if you use different prefixes, or put the ticket number in a different position (e.g., at the end of the branch name), simply edit `commit-msg` and change the following line to match your chosen pattern:

```python
pattern = r"^(feature|hotfix)/(?P<ticket>\d+)-.+"
```

The important part is `(?P<ticket>\d+)`; you must have a group with this name in your regex pattern for the hook to work.

There is actually only a single hook, `commit-msg`, which is also used (via a symlink) for `prepare-commit-msg`. Thus, the pattern only needs to be changed in one file, provided you use symlinks as described in the **Usage** section.

Acknowledgements
----------------
This hook was adapted from [Lorin Hochstein's gist](https://gist.github.com/lorin/2963131). I've change it to use a regex for the pattern, to make it easier to adapt to different branch naming conventions, and added a shell script, `apply.sh`, to make it easy to apply the hook to local git repositories. 