# cider-browse-ns.el

[Cider](https://github.com/clojure-emacs/cider) has awesome support for function documentation. 
I wanted to extend that support with a way to easily browse available namespaces and the functions
available within those namespaces.

This is alpha software and whatnot. Hopefully you find it useful!

## Usage

### cider-browse-ns

* `M-x cider-browse-ns`
* Display a list of all vars in a namespace.
* Pressing `enter` will take you to the cider-doc buffer for that var.
* Pressing `^` will take you "up" to a list of all namespaces (like dired mode)

### cider-browse-ns-all

* `M-x cider-browse-ns-all`
* Explore clojure namespaces by browsing a list of all namespaces.
* Pressing `enter` expands into a list of that namespace's vars as if by
* executing the command `(cider-browse-ns my.ns)`
* `q` to close popup buffer

## Installation

A package is available from [MELPA](http://melpa.milkbox.net/#/cider-browse-ns) . Just type `M-x package-install <return> cider-browse-ns <return>`. If that doesn't work you most likely need to source melpa. Follow the instructions here http://melpa.milkbox.net/#/getting-started

Then, in your init file, you can (optionally) make a key binding:

```el
(require 'cider-browse-ns)
(eval-after-load 'clojure-mode
  '(define-key clojure-mode-map (kbd "C-c M-b") 'cider-browse-ns-all))
```
