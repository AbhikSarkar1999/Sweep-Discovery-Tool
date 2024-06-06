**Sweep Discovery Tool: A Selective Sweep Prediction Tool in Specified Chromosomal Region**

Sweep Discovery Tool is a user friendly tool for detecting selective sweep in genomic regions. Selective sweep is a biological phenomenon in which genetic variation on a selected locus gets swept away due to increase in frequency of beneficial allele along with its surrounding alleles after fixation of beneficial mutation. 
Sweep Discovery Tool has been made using machine learning based Random Forest model in its server logic. The interface of tool has been developed through R Shiny program. 
User interface of the Sweep Discovery Tool consists of five tabs namely- 1) Home, 2) Predict, 3) Data Availability, 4) Developers and 5) Contact Details. 
Sweep Discovery Tool takes VCF file along with tabixed VCF file as input. User has to specify the region of interest for his/her study such as chromosome no, start position and end position. T
he tool predicts the selective sweep status of that specified region in terms of three classes such as i) No Selective Sweep, ii) Soft Selective Sweep and iii) Hard Selective Sweep. 
Sweep Discovery Tool is accessible through http://cabgrid.res.in:5599/ and maintained by ICAR-Indian Agricultural Statistics Research Institute, New Delhi, 110012

	**Instruction for users:-**
1. User has to provide input in gzipped VCF format (.vcf.gz) along with the tabix-indexed VCF file (.vcf.gz.tbi). VCF file must contain sample information properly.
2. User has to mention required input parameters such as “Chromosome No/Identifier”, “Start Position” and “End Position” along with the input files.

	**Prediction procedure: -**
1.Open the Sweep Discovery Tool.
2.Choose the “Predict Tab” from the home page.
3. Provide Input files together at first in the required format and mention a Directory name. Then press the “Save” button to save the files.
4. Now provide the necessary input parameters (Chromosome No/Identifier, Start Position and End Position) and finally click on “Predict” button for prediction.
5. After prediction, the result will be shown in the interface as well as user can download the result in “.csv” format from the “Download Results” button.

**Check the User Manual for further information**
