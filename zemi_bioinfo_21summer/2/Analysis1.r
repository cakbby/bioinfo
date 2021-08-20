# ゼミ第２回 R 解析

df <- read.table("fcount.tsv", header=T)
# delete cols
df <- df[, -c(2:5)]
# rename
names(df) <- c("Geneid","Length","LNCaP1","LNCaP2","LNCaP3","MR49F1","MR49F2","MR49F3")
head(df)

#論理インデックスによる操作
df<-df[!(df$LNCaP1==0 & df$LNCaP1==0 & df$LNCaP3==0 & df$MR49F1==0 & df$MR49F2==0 & df$MR49F3==0),]
rownames(df)<-NULL # reindexできる
head(df)


df_2 <- df[, -2]
rownames(df_2) <- df$Geneid
df_2 <- df_2[, -1]
df_2 <- as.matrix(df_2)
group <- factor(c(rep("LNCaP",3),rep("MR49F",3)))

# edgeRによるDEG判定
library("edgeR")
packageVersion("edgeR")

d <- DGEList(counts = df_2, group = group)
d <- calcNormFactors(d)
d

design <- model.matrix(~ group)
d <- estimateDisp(d,design)
fit <- glmFit(d, design)
result <- glmLRT(fit, coef = 2)

topTags(result)

FDR <- 0.01
logfc <- 1

edger_result <- as.data.frame(topTags(result, n = nrow(df_edger)))
isDEG <- as.logical(edger_result$FDR < FDR & abs(edger_result$logFC) > logfc)
deg_edger <- rownames(edger_result)[is.DEG]

upreg_edger <- rownames(edger_result)[as.logical(edger_result$FDR < FDR & edger_result$logFC > logfc)]
downreg_edger <- rownames(edger_result)[as.logical(edger_result$FDR < FDR & edger_result$logFC < -logfc)]

plotSmear(result, de.tags = deg_edger, cex=0.3)
write(deg_edger, file="deg_edger.txt")


# DESeq2
library("DESeq2")

group <- data.frame(con = factor(c(rep("LNCaP",3),rep("MR49F",3))))
dds <- DESeqDataSetFromMatrix(countData = df_2, colData = group, design = ~ con)
dds <- DESeq(dds)
deseq2_result <- results(dds)
head(deseq2_result)

isdeg_deseq2 <- as.logical(!is.na(deseq2_result$padj) & deseq2_result$padj < FDR & abs(deseq2_result$log2FoldChange) > logfc)
deg_deseq2 <- rownames(deseq2_result)[isdeg_deseq2]

upreg_deseq2 <- rownames(deseq2_result)[as.logical(!is.na(deseq2_result$padj) & deseq2_result$padj < FDR & deseq2_result$log2FoldChange > logfc)]
downreg_deseq2 <- rownames(deseq2_result)[as.logical(!is.na(deseq2_result$padj) & deseq2_result$padj < FDR & deseq2_result$log2FoldChange < -logfc)]

# MA plot
plot(log2(result_dds$baseMean), result_dds$log2FoldChange, pch=20, cex=0.2, xlab="A", ylab="M", xlim=c(-5, 20), ylim=c(-12, 12))
par(new=T)
plot(log2(result_dds[isdeg_deseq2,]$baseMean), result_dds[isdeg_deseq2,]$log2FoldChange, pch=20, cex=0.2, axes=F, col="red", xlab="A", ylab="M", xlim=c(-5, 20), ylim=c(-12, 12))
title("MA plot (DESeq2)")

plotMA(result_dds, alpha = 0.01)
