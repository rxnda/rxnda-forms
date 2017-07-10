# RxNDA Form Confidentiality Agreement

open form commercial confidentiality agreements

These forms are under active development toward first editions.  Feedback and contributions are _very_ welcome.  [See `CONTRIBUTING.md`](./CONTRIBUTING.md).

Download the most recent release from [GitHub](https://github.com/rxnda/rxnda-forms/releases) or [commonform.org](https://commonform.org/publications/rxnda), or sign and send online in minutes via [rxnda.com](https://rxnda.com).

## Be Warned!

**Contracts are prescription-strength legal devices.  If you need terms for exchanging confidential information, don't be an idiot.  Hire a lawyer.  A good one will ask good questions.  They may very well decide an RxNDA form meets your needs.**

**Do _not_ put confidential information about you, your work, or your clients in issues or pull requests.  Do _not_ ask for legal advice on GitHub, or try to disguise requests for legal advice as general questions or hypotheticals.  You don't want legal advice from anybody dumb enough to fall for that.**

## In Brief

The RxNDA Form Confidentiality Agreements are generic confidentiality agreements, also known as nondisclosure agreements or "NDAs", that aim to be:

- orthodox in substance, ticking all the boxes for NDAs used routinely between United States companies before exploring a sale or collaboration

- relatively modern in style, eschewing WHEREASes, NOW, THEREFOREs, nonsensical recitations of consideration, and other egregious anachronisms, but otherwise taking a prototypically lawyerly tone

- generic enough to reuse throughout United States jurisdictions

RxNDA Form Confidentiality Agreements do _not_ aim to cover situations where specialized, customized, or highly negotiated confidentiality agreements are the rational norm, such as confidentiality agreements:

- incorporating non-compete, non-solicitation, or no-hire provisions
- in anticipation of potential M&A transactions
- between clients and professional advisers or firms, such as banks acting as underwriters or brokers
- pertaining to specially regulated personal data, such as health or financial data
- pertaining to restricted military or government information, such as classified information
- between counterparties spanning national jurisdictions

## Variants

RxNDA Form Confidentiality Agreements come in several variants.  Each variant is identified with a unique code, like `B-2W-B2B` or `N-1W-B2I`.  The codes are easy to read.  For example:

    B      -      2W      -      B2B
    
    Broad         Two-Way        Business-to-Business

The `B-2W-B2B` form defines "Confidential Information" broadly, covers Confidential Information disclosed by both parties, and expects both parties to be businesses entities, rather than individuals.

On the other hand:

    N      -      1W      -      B2I
    
    Narrow        One-Way        Business-to-Individual

The `N-1W-B2I` form defines "Confidential Information" more narrowly, covers Confidential Information disclosed only by the first, proposing party to the second, and expects the disclosing party to be a business and the receiving party to be an individual.

Software generates all permutations of broad/narrow, one-way/two-way, and business-to-business, business-to-individual, individual-to-business, and individual-to-individual from a common template.  They share the vast majority of language in common, and are very easy to compare.

## Building

The repository has configuration to build copies of the terms in various formats, including Word, PDF, Markdown, and Common Form.

If you're alright agreeing to the terms of use for Microsoft's Core Fonts for the Web, for Times New Roman, the easiest way to build is probably with Docker:

```shellsession
git clone https://github.com/kemitchell/switchmode
cd switchmode
git checkout $edition
make docker
```

The `Dockerfile` uses a Debian Linux base image for Node.js, and installs other build tools from Debian package repositories.  If you want to build without Docker, have a look at the `RUN` lines in `Dockerfile` to see what you'll need.

## License

See [`LICENSE`](./LICENSE).
