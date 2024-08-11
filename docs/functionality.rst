Importing your documentation

To import a public documentation repository, visit your Read the Docs dashboard and click Import. For private repositories, please use Read the Docs for Business.
Automatically import your docs

If you have connected your Read the Docs account to GitHub, Bitbucket, or GitLab, you will see a list of your repositories that we are able to import. To import one of these projects, just click the import icon next to the repository you’d like to import. This will bring up a form that is already filled with your project’s information. Feel free to edit any of these properties, and then click Next to build your documentation.
../_images/import-a-repository.png

Importing a repository
Manually import your docs

If you have not connected a Git provider account, you will need to select Import Manually and enter the information for your repository yourself. You will also need to manually configure the webhook for your repository as well. When importing your project, you will be asked for the repository URL, along with some other information for your new project. The URL is normally the URL or path name you’d use to checkout, clone, or branch your repository. Some examples:

    https://github.com/ericholscher/django-kong.git

    https://gitlab.com/gitlab-org/gitlab

Add an optional homepage URL and some tags, and then click Next.

Once your project is created, you’ll need to manually configure the repository webhook if you would like to have new changes trigger builds for your project on Read the Docs. Go to your project’s Admin > Integrations page to configure a new webhook.