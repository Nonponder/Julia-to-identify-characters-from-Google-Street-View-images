# kaggle competition: identify characters from Google Street View images
my first competition...
the highest accuracy was 61.453%.
![](/rank.png)

Well, one of the most interesting part I think was that we did not use deep learning or other advanced mechine learning method, on the contrary, we paid great attention to data preprocessing. Finally the simplest classifier also has a very good performance.

preprocessing:
1. Extract grayscale
2. Convert to a 0-1 map by Maximum and minimum
3. Convert to a black background
4. [undo] maybe correct the character direction

use three type of classifier:
1. random forest, 500 trees. test performance was 61.45%
2. KNN, k=3. test performance was 53.04%
3. PCA + Bayesian network. test performance was 45.32%