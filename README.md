# cl-webapp-seed
A simple web application boilerplate using Common Lisp 

## Dependencies
- Hunchentoot
- cl-who

To run the demo locally, clone the repo and load it in you LISP environment.

Eg: In SBCL
```lisp
(ql:quickload :hello-world)
```

Then start the server
```lisp
(initialize-application :port 3000)
```

## Deployment
To deploy your app in a PaaS like Heroku, use the following buildpack

```
heroku apps:create hello-world --buildpack https://gitlab.com/duncan-bayne/heroku-buildpack-common-lisp
```

# Deploy it.
```
git push heroku master
```

# Open it in a browser.
```
heroku open
```
