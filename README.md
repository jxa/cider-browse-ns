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
* Pressing `^` will take you to a list of all namespaces (akin to dired mode)

### cider-browse-ns-all

* `M-x cider-browse-ns-all`
* Explore clojure namespaces by browsing a list of all namespaces.
* Pressing `enter` expands into a list of that namespace's vars as if by
* executing the command `(cider-browse-ns my.ns)`

## Installation

Packages will be coming soon. For now, install via git. Then, in your init file, require it and (optionally)
make a key binding:

```el
(require 'cider-browse-ns)
(eval-after-load 'clojure-mode
  '(define-key clojure-mode-map (kbd "C-c M-b") 'cider-browse-ns-all))
```
