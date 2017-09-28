# Elm Firebase SPA Boilerplate

> This repository has boilerplate code to help you get started working on an Single Page App website that uses [Elm](http://elm-lang.org/) and [Firebase](https://firebase.google.com/).

## Installing

### 1. Clone

```shell
git clone https://github.com/SidneyNemzer/elm-firebase-mdl-webpack my-app
```

Change `my-app` to the name of the folder you'd like to put the code in

### 2. Install

```shell
npm install
```

### 3. Make it yours

* Delete the `.git` folder. If you'd like to make your own git repository, run `git init`
* Update the `package.json` and `elm-package.json` with your app's information
* Update this README ([Here's a template](https://github.com/jehna/readme-best-practices/blob/master/README-default.md))
* Add a license (if you'd like)

## What's included

**Elm** is a functional language that compiles to JavaScript. Elm was designed to make websites! The architecture of an Elm app is similar to React + Redux. **Firebase** has several major features: user authentication, a real-time (aka super fast) nosql database, dynamic file storage (Google Cloud Storage), static website hosting, and Functions (Google Cloud Functions) which run can preform various tasks when triggered by a preset event (http request, database change, storage change, etc).

This repo includes a few other things to help you get started, beyond just Elm and Firebase:

* **Webpack** -- processes your application and recursively builds a dependency graph that includes every module your application needs, then packages all of those modules into a small number of bundles - often only one - to be loaded by the browser
* **Webpack Dev Server** -- provides a simple web server for development, and the ability to use live reloading
* **elm-github-install** -- Allows you to install Elm packages directly from Github. This should be used when the package isn't available on http://package.elm-lang.org/
* **elm-mdl** -- An Elm port of Google's Material Design Lite library
* **evancz/url-parser** -- Helps to figure out what route goes with a URL
* **elm-firebase** -- An Elm port of the firebase-js-sdk

### File Structure

The file structure for the frontend is based on [Richard Feldman's elm-spa-example](https://github.com/rtfeldman/elm-spa-example).
