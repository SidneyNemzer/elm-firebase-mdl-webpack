# Elm Firebase SPA Boilerplate

> This repository has boilerplate code to help you get started working on an Single Page App website that uses [Elm](http://elm-lang.org/) and [Firebase](https://firebase.google.com/).

## What's included

**Elm** is a language that compiles to Javascript. It can be used to make websites! The architecture of an Elm app is similar to React + Redux. **Firebase** has several major features: user authentication, a real-time (aka super fast) nosql database, dynamic file storage (Google Cloud Storage), static website hosting, and Functions (Google Cloud Functions) which run can preform various tasks when triggered by a preset event (http request, database change, storage change, etc).

This repo includes a few other things to help you get started, beyond just Elm and Firebase:

* **Webpack** -- Module bundler and builder. Takes the code you write and turns it into a single file to include on the frontend
* **Webpack Dev Server** -- A development server that runs on your computer to give you an auto-refreshing preview of your code
* **elm-github-install** -- Allows you to install Elm packages directly from Github. This should be used when the package isn't available on http://package.elm-lang.org/
* **elm-mdl** -- An elm port of Google's Material Design Lite library
* **evancz/url-parser** -- Helps to figure out what route goes with a URL
* **elm-firebase** -- An elm port of the firebase-js-sdk

### File Structure

The file structure for the frontend is based on [Richard Feldman's elm-spa-example](https://github.com/rtfeldman/elm-spa-example).
