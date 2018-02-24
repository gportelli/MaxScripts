## A Collection of Scripts for 3D Studio Max

Scripts in the *scripts* folder may include files from the *includes* folder.

To include a file in your script, just add something like this on top of your script:

*fileIn (getFilenamePath(getThisScriptFilename()) + "../includes/TFBT_Lib.ms")*

Here is a Sublime Text snippet you can use to include a script:

    <snippet>
        <content><![CDATA[
    if $1 == undefined then 
        fileIn (getFilenamePath(getThisScriptFilename()) + "${2:../includes/}$1.ms")
    ]]></content>
        <tabTrigger>include</tabTrigger>
        <description>Include a maxscript file at runtime</description>
    </snippet>


**Instructions**

type in the terminal:

*git clone git@github.com:gportelli/maxscripts Maxscripts*
