# Everything Library

A plugin allowing you to reference a folder of resources at runtime in an easy way. No `load()`, no `preload()`, no boilerplate directory crawling, no exported properties.

Handy when you have a list of resources you keep expanding and expanding, but also need a way to just get all of them - for **an in-game catalogue of monsters**, or for **a recipe list in a crafting system**, or **a script that** can't have exported properties but **needs that one specific Resource**...

## So,

let's say you have a folder of items. You need to `do_stuff()` with each item in the folder.

You press Project -> Tools -> Manage Everything Library (*or not, the window appears on first startup*). Add the folder, give it a name `items`.

Then you just:

    for item_resource in Library.items:
      do_stuff(item_resource)

If you have some `magic_crystal.tres` in that folder, you can just reference it directly, like:

    var crystal_item = Library.items["magic_crystal"]

If you're obsessed with optimization, you can erase the "key" field from the import entry, and they'll be stored in an array! Or maybe you just need to reference them by index. Or you need to index them by a specific property, then write it there! You could even have multiple entries importing the same folder but with different keys!

#
Made by Don Tnowe in 2022.

https://redbladegames.netlify.app

https://twitter.com/don_tnowe

Copying and Modification is allowed in accordance to the MIT license, full text is included.
