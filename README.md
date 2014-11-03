Angular Bower Gulp RequireJS Seed
===================

Installation
------------
* Add `./node_modules/.bin` to your PATH if it isn't there already
* npm install
* gulp
* start hacking

Deploying to Heroku
-------------------
* Create a new heroku app `heroku create APPNAME`
* Set the buildpack url `heroku config:set BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-nodejs.git`
* Make sure that application.rb in the Rails app includes the CORS config for this application
* Edit app/config-prod.json to point to the correct backend
* Push your app `git push heroku BRANCH:master`

Stack
------

### Application framework

* Gulp
* Bower
* RequireJS
* [AngularJS](https://angularjs.org/)
	* [UI-Router](https://github.com/angular-ui/ui-router)
	* [Bootstrap for angular](https://github.com/angular-ui/bootstrap)


### Testing

#### Unit

Uses default karma/jasmine provided by gulp-ng generator

#### E2E

[Protractor](https://github.com/angular/protractor)

run `gulp test:e2e` to start webdriver, single run tests and start watching
