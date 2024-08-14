=====================
Mongoid Documentation
=====================

This repository contains documentation for Mongoid, the object-document
mapper for MongoDB in Ruby.

Build Locally
-------------

To build the documentation locally, 

- Install `giza <https://pypi.python.org/pypi/giza/>`_, if not already
  installed. Note that giza requires Python 2.7 and does not work with Python 3.
  There is an `installation guide 
  <https://docs.mongodb.com/meta/tutorials/install/>`_ on the MongoDB meta site
  to help you get started.

- Run the following to download and build this documentation locally::

     git clone git@github.com:mongodb/docs-mongoid
     cd docs-mongoid/
     make html

The generated HTML will be placed in `build/master/html/`.

*Note*: The build process invokes Sphinx and expects Sphinx's various
binaries to be in PATH.

Stage
-----

Install `mut <https://github.com/mongodb/mut>`_ following its installation
instructions. Note that mut requires Python 3 and does not work with Python 2.7.

Request access to the documentation staging bucket. Obtain AWS S3
access key id and secret access key.

Create ``~/.config/giza-aws-authentication.conf`` with the following contents::

    [authentication]
    accesskey=<AWS access key>
    secretkey=<AWS secret key>

(If you run ``make stage`` without configuring authentication, it will
also give you these instructions.)

Finally to publish the docs to the staging bucket, run::

    make stage

The output will include a URL to the published documentation.

Deploy To Live Site
-------------------

Install `mut <https://github.com/mongodb/mut>`_ following its installation
instructions. Note that mut requires Python 3 and does not work with Python 2.7.

Request access to the production documentation bucket. Obtain AWS S3
access key id and secret access key.

Create ``~/.config/giza-aws-authentication.conf`` with the following contents::

    [authentication]
    accesskey=<AWS access key>
    secretkey=<AWS secret key>

Publish the docs to the production bucket::

    make publish deploy

Using Docker
------------

Build the docker image::

    docker build -t docs-mongoid .

Build the documentation to ``build`` subdir, clobbering its existing contents::

    rm -rf build && \
    mkdir build && \
    docker run -itv `pwd`/build:/build \
      docs-mongoid sh -c 'make html && rsync -av build/ /build'

Note that since Docker container runs everything as root, the built files
will also be owned by root and will require root access to modify or remove.

Deploy to live site (no need to configure ``~/.config/giza-aws-authentication.conf``
on the host system)::

    docker run -it \
      -e AWS_ACCESS_KEY_ID=<AWS access key> \
      -e AWS_SECRET_ACCESS_KEY=<AWS secret key> \
      docs-mongoid make publish deploy

Contribute
----------

To contribute to the documentation, please sign the `MongoDB
Contributor Agreement
<https://www.mongodb.com/legal/contributor-agreement>`_ if you have not
already.

See the following documents that provide an overview of the
documentation style and process:

- `Style Guide <http://docs.mongodb.org/manual/meta/style-guide>`_
- `Documentation Practices <http://docs.mongodb.org/manual/meta/practices>`_
- `Documentation Organization <http://docs.mongodb.org/manual/meta/organization>`_
- `Build Instructions <http://docs.mongodb.org/manual/meta/build>`_

File JIRA Tickets
-----------------

File issue reports or requests at the `Documentation Jira Project
<https://jira.mongodb.org/browse/DOCS>`_.

Listed Mongoid Branches
-----------------------

The branch list as well as which is the current one is maintained here: https://github.com/mongodb/docs-tools/blob/master/data/mongoid-published-branches.yaml

Licenses
--------

All documentation is available under the terms of a `Creative Commons
License <http://creativecommons.org/licenses/by-nc-sa/3.0/>`_.

The MongoDB Documentation Project is governed by the terms of the
`MongoDB Contributor Agreement
<https://www.mongodb.com/legal/contributor-agreement>`_.

-- The MongoDB Docs Team
