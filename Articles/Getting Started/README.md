# Office 365 for IT ProsPractical 365 Lab PowerShell examples

## Introduction
The files in this repository represent labs built by [Practical 365 Author Nicolas Blank](https://practical365.com/author/nicolas-blank/) for the purpose of creating repeatable guidance and builds which are reproducable by the readers.

These labs are built using [AutomatedLab](https://github.com/AutomatedLab/AutomatedLab) unless specified.

NOTE: Read the AutomatedLab documentation and become familiar with the lab toolset. I cannot provide technical support for anything Automated lab related. Please refer to the github project and the project authors for support.


## First time installation
When you build your AutomatedLab setup for the first time DO NOT use the MSI installer, rather install from the PowerShell Gallery using the cmdlet Install-Module. 

## Build principles
As the lab builds progress, this section will expand with more content. Reader feedback is welcome! This section in not meant to be an exhaustive howto guide, rather a section to share best practices and guidelines.

General notes :

1. When building out your lab host, specify the locations explicity where your virtual machines should be build, or AutomatedLab will decide for you with unintended consequences. Use the `-VmPath `parameter on the `New-LabDefinition` cmdlet to specify where your VMs are to be created.

2. Automated lab does a lot for you, including transparently authenticating your hyper-v client sessions. Don't use the defaults, rather depart from the Automated Lab model and Enable Enhanced Session Mode on the Host using the following PowerShell command
        `Set-VMHost -EnableEnhancedSessionMode $True`

3. Unless you specify differently, the labs Default Administrator password is > "Somepass1"
 