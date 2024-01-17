# auto_emr
This is a simple example of how to use autohotkey and Ollama with mistral to interact with a popular EHR/EMR software and get summarized data back

# Cloning the repository
git clone https://github.com/apyrros/auto_emr

# Install ollama (https://ollama.ai/)
'curl https://ollama.ai/install.sh | sh'

'ollama serve mistral'

#Install Autohotkey
You will need to download autohotkey v1.1 (https://www.autohotkey.com/download/).


# Usage
# OllamaEHR.ahk
This will create a basic GUI interface to Ollama. Clicking a prompt will select the EHR window, copy and then send them to your Ollama instance running locally.
In the script please set the URL accordingly: 
Url := "http://127.0.0.0.1:11434/"

Prompts and layout of the Window can be edited in the script to.
Be warned, Mistral can and will hallucinate data.
This is for testing/researching purposes only. 

# License
This work is licensed under a Creative Commons Attribution-NonCommercial 4.0 International License. This license allows reusers to copy and redistribute the material in any medium or format and remix, transform, and build upon the material, as long as attribution is given to the creator. The license allows for non-commercial use only, and otherwise maintains the same freedoms as the regular CC license.

This software, "Auto RadReport," is provided as a prototype and for informational purposes only. It is not necessarily secure or accurate and is provided "as is" without warranty of any kind. Users should use this software at their own risk.

We make no representations or warranties of any kind, express or implied, about the completeness, accuracy, reliability, suitability or availability with respect to the software or the information, products, services, or related graphics contained on the software for any purpose. Any reliance you place on such information is therefore strictly at your own risk.

This software is not intended for use in medical diagnosis or treatment or in any activity where failure or inaccuracy of use might result in harm or loss. Users are advised that health treatment or diagnosis decisions should only be made by certified medical professionals.

In no event will we be liable for any loss or damage including without limitation, indirect or consequential loss or damage, or any loss or damage whatsoever arising from loss of data or profits arising out of, or in connection with, the use of this software.

By using this software, you agree to this disclaimer and assume all risks associated with its use. We encourage users to ensure they comply with local laws and regulations and to use the software ethically and responsibly.

For more information, please visit Creative Commons Attribution-NonCommercial 4.0 International License.
