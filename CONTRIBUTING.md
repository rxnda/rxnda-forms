# Contributing to RxNDA Forms

Feedback and contributions are _very_ welcome.

If your feedback has to do with language shared across several RxNDA forms, or with the RxNDA form set in general, please [open a new GitHub issue on the rxnda-forms repository](https://github.com/rxnda/rxnda-forms/issues/new).

If your feedback has to do with a specific RxNDA form, and have a look at the most recent GitHub release.  You can download Word or PDF copies if that's how you prefer to work.

If you use GitHub, feel free to open issues or send pull requests.  You can also send e-mail to <forms@rxnda.com>, especially if you prefer to collaborate privately.  Your preference, for recognition or for privacy, will be honored.

## Licensing

See the `LICENSE` file in each form repository.

The public license has language about licensing contributions.  But please expect that you may be asked for written confirmation acknowledging the license and making your contributions available on its terms.

## Source Files

Each form repository contains a `.cftemplate` file with its terms, plus other files used to build the complete form.  The repositories use [rxnda-build-chain](https://github.com/rxnda/rxnda-build-chain) as a submodule for configuration to build Microsoft Word, PDF, HTML, and other copies.  The easiest way to build a form from source on your machine is probably to install [Docker](https://docker.com) and run `make docker`.  This will download Linux base images and build tools, render the form, and copy the results back to your machine.

See [commonform-markup-parse](https://www.npmjs.com/package/commonform-markup-parse) for a description of the markup syntax used to describe form content.  See [cftemplate](https://www.npmjs.com/package/cftemplate) for a description of the markup tags, like `((if X begin))...((end))` used describe differences between variants.
