# Contributing to RxNDA Forms

Feedback and contributions are _very_ welcome.

Have a look at the most recent [release](https://github.com/kemitchell/rxnda-forms/releases).  You can download Word or PDF copies if that's how you prefer to work.

If you use GitHub, feel free to open issues or send pull requests.  You can also send e-mail to <forms@rxnda.com>, especially if you prefer to collaborate privately.  Your preference, for recognition or for privacy, will be honored.

## Licensing

See [`LICENSE`](./LICENSE).

The public license has language about licensing contributions.  But please expect that you may be asked for written confirmation acknowledging the license and making your contributions available on its terms.

## Source Files

The main file containing form content is [`master.cftemplate`](./master.cftemplate).  All of the forms are built from that master file.

See [commonform-markup-parse](https://www.npmjs.com/package/commonform-markup-parse) for a description of the markup syntax used to describe form content.  See [cftemplate](https://www.npmjs.com/package/cftemplate) for a description of the markup tags, like `((if X begin))...((end))` used describe differences between variants.
