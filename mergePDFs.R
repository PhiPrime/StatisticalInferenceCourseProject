## This script is to merge the Report and Appendix PDFs
library(pdftools)
pdf_combine(c(
        "./CLT_Simulation_(Part_1)/Report/CLT_With_Exponetial_Distribution.pdf",
        "./CLT_Simulation_(Part_1)/Appendix/Appendix.pdf"),
        output = "./CLT_Simulation_(Part_1)/CombinedReport.pdf")
pdf_combine(c(
"./ToothGrowth_Analysis_(Part_2)/Report/An_Analysis_of_ToothGrowth_Data.pdf",
"./ToothGrowth_Analysis_(Part_2)/Appendix/Appendix.pdf"),
        output = "./ToothGrowth_Analysis_(Part_2)/CombinedReport.pdf")
