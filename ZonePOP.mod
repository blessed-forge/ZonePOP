<?xml version="1.0" encoding="UTF-8"?>
<ModuleFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <UiMod name="ZonePOP" version="1.3.1" date="03/07/2017">
	<VersionSettings gameVersion="1.4.8" windowsVersion="1.0" savedVariablesVersion="1.0" /> 
     <Author name="Sullemunk" />
        <Description text="Shows the population in your current zone" />
             <Dependencies>           
      		<Dependency name="LibSlash" optional="false" forceEnable="true" />
		
			
        </Dependencies>
        <Files>
            <File name="ZonePOP.lua" />
             <File name="ZonePOP.xml" />
        </Files>
        <OnInitialize>
            <CallFunction name="ZonePOP.init" />
        </OnInitialize>
        <OnUpdate>
			<CallFunction name="ZonePOP.Update"/>
    	  </OnUpdate>
        <OnShutdown />
    </UiMod>
</ModuleFile>