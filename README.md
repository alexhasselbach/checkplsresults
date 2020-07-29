## checkplsresults
Author: Alex Hasselbach<br>
Buckeye Brain Aging Lab, The Ohio State University

# Summary
This function is for looking through the results of a behavioral PLS correlation analysis and creating readable and interpretable output.<br>
PLS UserGuide: http://pls.rotman-baycrest.on.ca/UserGuide.htm

## PLS summary
PLS is a factor analysis technique that works by generating a correlation matrix between 2 types of variables (e.g. behavior and cognition) and performing singular value decomposition on that matrix, similar to a PCA. 
This is a way to capture which dimensions of the matrix capture the most variance (aka latent variables) while also being able to parse out which input variables align best with those variance dimensions.
Note that **all** input variables inherently contribute to the matrix; this code just helps you see which ones are contributing significantly to the latent variables.
Also note that SVD does not produce true eigenvectors of the correlation matrix, because the correlation matrix is not necessarily square.
This has the effect of forcing the results of the PLS into the number of dimensions of the first matrix you input.
This means you need to be aware of 2 things when using PLS correlation generally:
- Results are interpretted differently for each component of the correlation matrix; for the first input matrix, you can just look at how each variable correlates with the latent variable since the dimensions match. 
The second set of variables is evaluated by using bootstrap testing to find a false positive rate; see the User Guide and Message Board for more information.
- You must not use more variables in the first input matrix than the number of subjects in your dataset. Having more subjects than variables overspecifies your PLS, since you would end up having less than 1 subject per LV!
