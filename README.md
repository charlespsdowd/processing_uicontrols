# processing-uicontrols
UI Elements and Controls for Processing

This repository is my work in progress trying to create a set of UI controls to use with processing.

The repository uses two tyoe of objects.
- *Views* 
- *View Controllers*

The *View* is the UI element an the *ViewController* is a basedline implmention of the UI delegates for that *View*.

## Interfaces (protocols)
1. Processable
1. Actionable

## Views
1. class View
2. class Window extends View
2. class Button extends View
1. class SliderButton extends Button
1. class ScrollBar extends Window
1. class ScrollView extends View
1. class CollectionView extends Window 

## ViewControllers
1. class ViewController
1. class ScrollViewController extends ViewController 
1. class CollectionViewController extends ScrollViewController

## Sample ViewControllers
1. class DetailsViewController extends ScrollViewController
1. class GeneralCollectionViewController extends CollectionViewController
1. class MainViewController extends ViewController

# How to use this repository
Start by reviewing the file **processing_uicontrols.pde** as it congatins a sample _app_ using a Window and a CollectionView together. 
