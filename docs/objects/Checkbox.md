With checkbox, the user can set a bool to true or false

Here are all possible functions available for checkbox:<be>
 Remember checkbox inherits from [object](https://github.com/NoryiE/NyoUI/wiki/Object):


Create a onChange event:
````lua
local mainFrame = basalt.createFrame("myFirstFrame"):show()
local aCheckbox = mainFrame:addCheckbox("myFirstCheckbox"):onChange(function(self) basalt.debug("The value got changed into "..self:getValue()) end):show()

````
