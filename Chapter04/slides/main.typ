#import "@preview/polylux:0.3.1": *
#import "@preview/tablex:0.0.7": tablex, cellx

// HACK NEEDED for correct emoji PDF output. see 
// https://github.com/typst/typst/issues/144 
// and the workaround 
// https://github.com/polazarus/typst-svg-emoji?tab=readme-ov-file
#import "@local/svg-emoji:0.1.0": setup-emoji
#show: setup-emoji 

#import "metropolispt2.typ": * 
// copied the whole theme over in case we want to modify it

#show: metropolis-theme.with(
  // footer: [Classification]
)
// https://polylux.dev/book/themes/gallery/metropolis.html


#set text(font: "Atkinson Hyperlegible", weight: "light", size: 20pt)


#show "python": _ => {box(height: 1.3em,baseline: 0.5em)[#image("pics/python-3.svg")]}

#show "curse": _ => {$frak(c u r s e)$} 

#show "KNN": _ => {$K$+"NN"}

// #show "Wikipedia": name => {h(-0.4em) + box(height: 1.7em,baseline: 0.5em)[#image("pics/wiki.png")] + h(-0.1em) + name}

#show "Confounding": name => {text(font: "Permanent Marker",name)}

#show "ISLP": _ => highlight(fill: rgb("E8AE27").darken(10%), text(weight: 400, fill: white, font: "Fira Sans", "ISL")+text(weight: 400, fill: black, font: "Fira Sans", "P"))

// #show math.equation: set text(
//   // font: "Libertinus Math", 
//   size: 21pt)
// #show raw: set text(fill: red.darken(70%))


#set strong(delta: 300)
#set par(justify: true)

#set list(marker: "•")
#show link: set text(fill: blue.darken(20%))

#let myblock-title(
  fill: gradient.linear(blue.darken(50%),blue), 
  text-fill: white,
  body
) = {
  block(
      width: 100%, 
      radius: (top: 1em), 
      outset: 0.5em,
      fill: fill,
      text(weight: "bold", fill: text-fill, body)
  )
}

#let myblock(
  title: "", 
  fill: gradient.linear(yellow.lighten(70%),orange.lighten(80%)), title-fill: gradient.linear(blue.darken(50%),blue), 
  width: 80%,
  body
) = { 
  align(center)[
    #block(
      width: width, 
      breakable: false,
      radius: 1em, 
      outset: 0.5em,
      fill: fill,
      [
        #align(left)[
        #if title != "" {
          [#myblock-title(fill: title-fill, title)] 
          v(0.3em)
        }
        #{body}
      ]
    ]
    )
  ]
}

#let question(title: "", body) = myblock(title: title, fill: gradient.linear(red.lighten(90%),orange.lighten(90%)), title-fill: gradient.linear(red.darken(10%),red.darken(30%)), width: 95%, body)

#let answer(body) = {[*Answer* ] + text(fill: green.darken(50%), body)}

#let incline = {box(baseline: -0.3em)[#image(height:1em,"pics/road.svg")]}

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// SLIDES BEGIN NOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#title-slide(
  title: "Classification",
  subtitle: [Slides on _Introduction to Statistical Learning_, Chapter 4],
  author: [Calvin Khor],
  date: [January 2024],
  extra: [See the Typst source: https://typst.app/project/r9bqFQZQAD5m2ttHgsjSu_]
)

#slide(title: "Table of contents")[
  #metropolis-outline
]

#new-section-slide("Overview of Classification")

#slide(title: "What?")[
- (supervised) *classification*: #alert[prediction] of a #alert[*qualitative*] response variable $Y$
- as opposed to regression, which predicts a #emph[quantitative] response.
]

#slide(title: "Examples")[
  
  #side-by-side(columns: (0.8fr, 2fr, 1fr))[
    #image("pics/wood.jpg") 
    
  ][
    #image("pics/detexify.png") 
  ][
    #image("pics/captcha.png")
    
  ]
]

#slide(title: "Book's Examples")[
  - Detecting illness from symptoms
  - Detecting fraud
  - Understanding effects of genes on a disease
]

#slide(title: [Real Examples (Kernelised: see #link("https://en.wikipedia.org/wiki/Kernel_Fisher_discriminant_analysis")[Wikipedia])])[
  #side-by-side[
    #image(height: 80%, "pics/eg1.png") 
     "[...] a new kernel function, called the cosine kernel, [...]" #link("https://doi.org/10.1109/TCSVT.2003.818352")[DOI link]
  ][
    #image(height: 80%, "pics/eg2.png")
    used for Higgs Boson. #link("https://doi.org/10.1016/S0010-4655(97)00100-8")[DOI Link]
  ]
]

#slide(title: "Aside: Detexify and its training data is open source")[
  Detexify  #link(
      "https://gist.github.com/kirel/149896#"
    )[uses KNN]:
  
#quote(attribution: "https://gist.github.com/kirel/149896#")[
The classification in Detexify is implemented with the k-nearest neighbor algorithm (almost). To classify an unknown pattern the training data is first sorted based on the euclidean distance in the feature space to this pattern. Usually then the k nearest neighbours are examined and the pattern is probably of the class most common among them but since I want 5 entries in the hit list of symbols nearest neighbours are examined until symbols of 5 different classes are found. The score of a symbol (class) is then the number of occurences among these nearest neighbours.]

Links: #link("https://github.com/kirel/detexify-data")[training data], #link("https://github.com/kirel/detexify-hs-backend/tree/master/src")[Haskell backend], #link("https://github.com/kirel/detexify")[frontend]
]

#slide(title: "What we cover and what we don't")[
  #side-by-side[
    #set list(marker: [✅]) 
    - Logistic Regression
    - Linear Discriminant Analysis (LDA)
    - Quadratic Discriminant Analysis (QDA)
    - Naïve Bayes
    - Generalised Linear Models (not really classification)
  ][
     #set list(marker: ([❌],"-")) 
     - Generalised Additive Models 
      - that's chapter 7     
    - Tree methods
      - that's chapter 8
    - Support Vector Machines 
     - that's chapter 9
    - Clustering 
      - that's unsupervised (chapter 12)
    - deep learning
      - that's chapter 10
  ]
]

#new-section-slide("Why not linear regression?")

#slide(title: "Linear Regression for categorical variables?")[
  - Encoding of categories enforces an order (possibly even weighted)
  $ 
  Y = cases(
    1 "if" #[`stroke`], 
    #text(fill: red)[2] "if" #[`drug overdose`], 
    #text(fill: green)[3] "if" #[`epileptic seizure`], 
  ) 
  "or" 
  Y = cases(
    #text(fill: red)[2] "if" #[`stroke`], 
    #text(fill: green)[3] "if" #[`drug overdose`], 
    1 "if" #[`epileptic seizure`], ) 
    "or ...?" 
    $  
  - More natural for binary response, e.g. 
  $ Y = cases(0 "if" #[`stroke`], 1 "if" #[`drug overdose`] ) $ 
  - We can model $PP(#[`drug overdose`] |X) = X beta$. 
  - Flipping the encoding $0<->1$ will give the same predictions
  - but linear functions $X |-> X hat(beta)$ are unbounded in range: how to interpret if $X hat(beta) in.not [0,1]$?
]

#slide(title: "Plot from ISLP 2nd Ed. Page 139")[
    #align( center )[#image(height: 69%, "pics/linearmodel.png")]  
    
  
      #myblock(title: "Conclusion")[
      - cannot use linear regression for more than 2 categories
      - doesn't provide meaningful estimates for probabilities
    ]
]

#new-section-slide("Logistic Regression")

#slide(title: "Logistic Regression")[
  - Instead of modelling $p(X) = PP(Y=1|X)$ with the linear regression model $p(X) = beta_0 + beta_1 X$, we#footnote[I got the $sigma$ from #link("https://en.wikipedia.org/wiki/Logit")[Wikipedia's Logit page]. Presumably sigma for sigmoid.] can use the *logistic function* $sigma(x) = e^x/(1+e^x) = 1/2 + 1/2 tanh(x/2)$:
    $
    p(X) = e^(beta_0 + beta_1 X)/(1 + e^(beta_0 + beta_1 X)) = sigma(beta_0 + beta_1 X)
    $ 
  - Since $sigma$ takes values in $(0,1)$, the model will give _interpretable_ results.
  - The inverse function is called the *logit* function: $ op("logit")(y) = sigma^(-1) (y) = log y/(1-y). $
  - We have $op("logit")(p(X)) = beta_0 + beta_1 X$. The quantity $op("logit")(p(X))$ is called the *logit*, or *log-odds*. 
]

#slide(title: "Logistic Plots")[
  #image("pics/logistic.png")
  #text(fill: red.darken(30%))[
    $y = sigma(x) = e^x/(1+e^x)$
  ] 
  #h(1fr) 
  #text(fill: orange)[
    $x=a$
  ]
  #h(1fr) 
  #text(fill: blue)[
    $y = sigma(m(x-a)), quad  m>1$
  ]   
  #h(1fr) 
  #text(fill: green.darken(40%))[
    $y = m/4(x-a) + 1/2$
  ] 
]

#slide(title: "Logit Plot")[
  #side-by-side(columns: (60%,40%))[
    - plot of $y=op("logit")(x)$ from #link("https://en.wikipedia.org/wiki/Probit")[Wikipedia].
      - near $x=0$, logit $approx$ scaled "probit" a.k.a. gaussian ppf.
      - #link("https://bayesium.com/which-link-function-logit-probit-or-cloglog/")[Link on link functions]. More on other "link" functions at the end. (GLM) 
  ][
    #image("pics/logitplot.png")
  ]
]

#slide(title: "Second Plot from ISLP 2nd Ed. Page 139")[
    #align( center )[#image( "pics/logisticmodel.png")]  
]

#slide(title: "Fitting with Maximum Likelihood Estimation")[
  - We could fit  $op("logit")Y$ with least squares or nonlinear least squares on $Y$ but this is unnatural.
  - More principled approach: Maximum Likelihood Estimate (MLE).
  - The *likelihood function* $ell (x,beta)$ is the probability of observing $x$ if we were sampling from the model with parameters $beta$. 
  - Idea: select the parameter values that make the observed data most probable, i.e. if $cal(B)$ denotes the space of all parameters $beta$ then
  #myblock[
  $
  hat(beta) = op(limits: #true, "argmax")_(beta in cal(B)) ell(beta).
  $]
  - For logistic regression, where $p(X) = PP(Y=1|X)$,
  $
  ell(beta_0, beta_1) = product_(i:y_i=1)p(x_i)product_(i:y_i=0)(1-p(x_i)).
  $
  - In python, we can ```python from sklearn.linear_model import LogisticRegression```.
]

#slide(title: [Multiple Logistic Regression ($p>1$)])[
  - Rinse and repeat with  $X in RR^(1 times p)$, $beta in RR^p$,
  $
  p(X) = sigma(X beta)=e^(beta_0 + X_1beta_1 + dots + X_p beta_p)/(1+e^(beta_0 + X_1beta_1 + dots + X_p beta_p)).
  $
  - With $p>1$, there can be Confounding (as in multiple linear regression):

    - coefficients can vary wildly as you add features due to lack of independence. 
]
#slide(title: "Confounding Data Example: Probability of default")[
  Tables 4.1, 4.2, 4.3 in ISLP 2nd Ed. (simplified, pages 142, 143) 
  
  `student[Yes]` is one-hot encoded.
  #set table(
    stroke: none, 
    columns: (auto, auto, auto, auto), 
    align: right
  ) 
  #side-by-side[
    
    #table(
      [],[coeff],[std error],[$p$-value],
      [`intercept`], [-3.504], [0.071], [\<0.0001],
      [`student[Yes]`], text(fill: green.darken(30%))[0.405], [0.1150], [0.0004]
    )

    #table(
      [],[coeff],[std error],[$p$-value],
      [`intercept`], [-10.651], [0.361], [\<0.0001],
      [`cc balance`], [0.0055], [0.0002], [\<0.0001]
    )
    
  ][
    #table(
      [],[coeff],[std error],[$p$-value],
      [`intercept`], [-10.869], [0.492], [\<0.0001],
      [`cc balance`], [0.006], [0.0002], [\<0.0001],
      [`income`], [0.003], [0.008], [0.712],
      [`student[Yes]`], text(fill: red.darken(30%))[-0.647], [0.236], [0.006]
    )
  ]
]
#slide(title: "Confounding Plots (ISLP 2nd Ed. page 143)")[
  #align(center)[
   #image(width: 70%, "pics/confounding.png")
   (Univariate analysis) Students are #highlight(fill: yellow.lighten(20%))[more likely to default as a group] 
   but 
   
   (Multivariate analysis) #highlight(fill: green.lighten(40%))[less likely to default for a given credit card balance] 
   
   Resolution: students #highlight(fill: red.lighten(60%))[tend to have a higher balance.]
 ]
]
#slide(title: [Multinomial Logistic Regression (\#categories $K>1$)])[
  - Choose one class to be the "baseline", say the $K$th one. Then we model
  $
  PP(Y=K | X) &= 1/(1+ sum_(i=1)^(K-1) e^(X beta_i)),&\
  PP(Y=k | X) &= e^(X beta_k)/(1+ sum_(i=1)^(K-1) e^(X beta_i)), &quad  k=1, dots ,K-1.
  $
  where now $X in RR^(1 times p), beta_i in RR^p$,  $X beta_i = sum_j X_j beta_(i j) in RR, i=1,dots, K$. 
  - It follows
  $
  log PP(Y=k | X)/PP(Y=K | X) &= X beta_k = beta_(k 0) + beta_(k 1) X_1 + dots + beta_(k p) X_p .
  $
]
#slide(title: [Multinomial Logistic Regression with softmax encoding])[
  - The "softmax" encoding treats each category symmetrically: for $k=1,dots, K$:
  $
  PP(Y=k | X) = e^(X tilde(beta_k))/(sum_(i=1)^(K) e^(X tilde(beta_i)))#uncover(2)[$=e^(X (tilde(beta_k)-tilde(beta_K)))/(1 + sum_(i=1)^(K-1)e^(X(tilde(beta_i) - tilde(beta_K))))$.]
  $
  with the obvious link $beta_k = tilde(beta_k) - tilde(beta_K)$.
  - NB The function $sigma: RR^N -> (0,1)^N$ whose $i$th component is 
  $
  sigma_i (v_1, dots v_N) = e^(v_i)/(sum_(j=1)^N e^(v_j))
  $
  is the softmax function used in Machine Learning #emoji.robot
]
#slide[
    #myblock(title: "Summary for Logistic Regression")[
    - (Multiple) Logistic Regression models the log-odds $(log p/(1-p))$, where $p(x)=PP(Y=k|X=x)$, by a linear function $X beta$.
    - Fitting is done by maximum likelihood estimation (_not_ OLS)
    - Beware of Confounding in the $p>1$ case
    - Can be modified for more than 2 categories (Multinomial Log. Regr.)
    
  ]
]
#new-section-slide("Generative Models for Classification")
#slide(title: "Discriminative vs Generative")[
  - Recall the Bayes classifier is the theoretically optimal classifier (classifying according to which of $PP(Y=k|X=x)$ is largest; assumes we know $PP(Y=k|X=x)$)
  - Logistic regression is a "discriminative" model which directly estimates  $PP(Y=k|X=x)$ with sigmoids.
  
  - We now consider a different way to approximate the Bayes classifier: we estimate each term that appears in Bayes' Theorem,
  $
  PP(Y=k|X=x) = (PP(X=x|Y=k)PP(Y=k))/PP(X=x). 
  $
  - Why consider these methods?
    + The MLE in logistic regression may not exist (not really issue for prediction)
    + Improved accuracy if $X$ are approximately normal and data is lacking
  - These methods will also generalise to $K>2$, like multinomial logistic regression.
]
#slide(title: [Notation: the prior $pi_k$, the posterior $p_k$, and the likelihood $f_k$])[Bayes:
    $
  PP(Y=k|X=x) = (PP(X=x|Y=k)PP(Y=k))/PP(X=x). 
  $
  - For ease of notation, define
  $
   pi_k = PP(Y=k), #h(3em)
   p_k (x) = PP(Y=k|X=x), \
   f_k (x) = PP(X=x|Y=k).
  $
  Then $PP(X=x)=sum_ell pi_ell f_ell (x)$ (law of total probability) and Bayes can be written 
  #myblock[
  $
  p_k (x) = (pi_k f_k (x))/(sum_ell pi_ell f_ell (x))
  $]
]
#slide(title: [Estimating $pi_k$ and $f_k$])[
  #myblock(title: "Bayes' Theorem")[
  $
  p_k (x) = (pi_k f_k (x))/(sum_ell pi_ell f_ell (x))
  $]
  
  - $pi_k$  is easy to estimate from the data: just take the proportion that are in class $k$.
  - $f_k$ is much harder. We will make simplifying assumptions and arrive at 3 methods:
    1. Linear Discrimant Analysis (LDA)
    2. Quadratic Discriminant Analysis (QDA)
    3. Naïve Bayes
  - approximate Bayes classifier $arrow.squiggly$ classify according to the largest of the $p_k$s.
]
#slide[
  = Linear Discriminant Analysis \ and Quadratic Discriminant Analysis
]

#slide(title: [Fisher's Linear Discriminant Analysis, $p=1$: the discriminant])[
  - For LDA, we assume that $(X|Y=k) tilde  N(mu_k, sigma^2)$, i.e.
  $
    f_k (x) = 1/((2pi)^(1\/2)sigma) exp((-(x-mu_k)^2)/(2sigma^2))
  $
  - Plugging into $p_k (x)= (pi_k f_k (x))/(sum_ell pi_ell f_ell (x))$ and taking logs:
  $
  log p_k (x) 
  &=log pi_k 
    - (x-mu_k)^2/(2sigma^2) 
    - log( sum_(ell=1)^K 
        pi_ell e^(
          #text(fill: red)[$-x^2/(2sigma^2)$]
          + (x mu_ell)/sigma^2
          - mu_ell^2/(2sigma^2)
        )
      ) \
  &=underbrace(
    log pi_k + (x mu_k)/sigma^2 - mu_k^2/(2 sigma^2),
    delta_k (x)
  ) + "stuff independent of" k
  $
  - So to pick the largest of the $p_k (x)$, it is enough to pick the largest *discriminant* $delta_k (x)$.
  // $
  // delta_k (x) := log pi_k + (x mu_k)\/sigma^2 - mu_k^2\/(2 sigma^2).
  // $
]
#slide(title: [Linear Discriminant Analysis, $p=1$: estimating parameters])[
  -  _linear_ discriminant because $delta_k (#text(fill: red)[$x$]) = log pi_k + (#text(fill: red)[$x$] mu_k)/sigma^2 - mu_k^2/(2 sigma^2)$ is linear.
  -  we put (simplest case)  $n_k = \#{i: y_i = k}$, and
  $
  hat(pi)_k = n_k/n, #h(2em)
  hat(mu)_k = 1/n_k sum_(i: y_i=k )x_i, \
  hat(sigma)^2= 1/(n-K) sum_(k=1)^K sum_(i: y_i=k )(x_i - hat(mu)_k)^2.
  $
]
#slide(title: "LDA Example (ISLP Fig 4.4, page 148)")[
  #align(center)[
    #side-by-side(columns: (80%, 50%))[#image(height: 55%,"pics/LDA.png")][]
  ]
  #side-by-side(columns: (36%, 60%))[
    Two one-dimensional normal density functions are shown. The dashed vertical line represents the Bayes decision boundary.
  ][20 observations were drawn from each of the two classes, and are shown as histograms. The Bayes decision boundary is again shown as a dashed vertical line. The solid vertical line represents the LDA decision boundary estimated from the training data. ]
]
#slide(title: [LDA, $p >= 1$])[
  -  We assume $(X | Y=k) tilde N(mu_k, Sigma)$ i.e.
  $
  f_k (x) = 1/((2pi)^(p\/2)|Sigma|^(1\/2))exp((-(x-mu_k)^T  Sigma^(-1) (x-mu_k ))/2)
  $
  - leads again to the linear discriminant
  $
  delta_k (x) = log pi_k + x^T Sigma^(-1) mu_k - 1/2mu_k^T Sigma^(-1) mu_k
  $
  - and we can similarly estimate
  $
  hat(pi)_k = n_k/n, #h(2em)
  hat(mu)_k = 1/n_k sum_(i: y_i=k )x_i, #h(2em)
  hat(Sigma) = 1/(n-K) sum_(k=1)^K sum_(i: y_i=k) (x_i - hat(mu)_k)  (x_i - hat(mu)_k)^T.
  $
]
#slide(title: [LDA plot, $p=2, K=3$ (ISLP Fig 4.6, page 151)])[
  #image("pics/LDA2.png")
]
#slide[
  #align(center)[(#link("https://www.youtube.com/watch?v=aUlTqhDtpnw&list=PLoROMvodv4rOzrYsAxzQyHb8n_RWNuS1e&index=21")[ISLR video on LDA])
  #image(height: 90%, "pics/LDA-ISLRvideo.png")]
]
#slide(title: [LDA example: predicting default from balance and student status#h(-1em)])[
  - Model evaluation on training set with a *confusion matrix* (ISLP Table 4.4, page 152):
    #align(center)[#table(
    align: right,
    columns: (auto, auto, auto, auto),
    stroke: none,
    [], [True No], [True Yes], [Total], 
    [Predict No], [9644], [252], [9896], 
    [Predict Yes], [23], [81], [104], 
    [Total], [9667], [333], [10,000], 
  )]
  - Overall training error rate is $(23+252)/10000=#{(23+252)/10000*100}%$.
   #side-by-side(columns: (20%,auto))[- not _test_ error][- the trivial classifier has error rate $333/10000=#{333/100}%$]
  -  For binary classifiers, can consider false positive and false negative rates:
    - $"FPR" = 23/9667 = 0.2%$, and $"FNR" = 252/333=75.7%$.
    - $"specificity" = 1 - "FPR" = 99.8%$ and $"sensitivity" = 1 - "FNR" = 24.3%$.
  - LDA $approx$ Bayes which minimises total error: no guarantees on false pos/negative rate.
]
#slide(title: [LDA example: tuning for better false negative rate (ISLP pg. 154)])[
  - LDA for 2 classes assigns to the $k$ for which $PP(Y=k | X) > p_0 =0.5$. 
  - We can adjust the threshold $p_0$ to improve the sensitivity.
  #side-by-side(columns:(40%,60%))[Training confusion matrix, $p_0=0.2$
    #table(
    align: right,
    columns: (auto, auto, auto, auto),
    stroke: none,
    [], [ No], [Yes], [Total], 
    [Pred No], [9432], [138], [9570], 
    [Pred Yes], [235], [195], [430], 
    [Total], [9667], [333], [10,000], 
  )
  $"sensitivity" = 41%,\ "total error"=3.73%.$
  ][
    #image(height: 55%,"pics/threshold.png")
    #box(baseline: -0.2em)[#line(stroke: 1.5pt, length: 2em)] total error 
    #h(1em)
    #box(width: 2em, baseline: -0.2em)[
      #for _ in range(4){
        box[#circle(fill: orange.darken(10%), radius: 0.07em)]
        h(0.35em)
      }
    ] specificity
    #h(1em)
      #for _ in (1,2) {
        box(baseline: -0.2em)[
          #line(stroke: (thickness: 3pt, paint: blue, cap: "round"), length: 0.6em) 
        ]
        h(0.4em)
      } sensitivity
  ]
]
#slide(title:"ROC curve")[
  #side-by-side[#image("pics/ROC.png")][
    -  best classifier will have a #text(fill: blue)[$#rotate(90deg,$angle.right$)$] shape
    - $y=x$ is the completely useless classifier
    - Area Under Curve (AUC): number that summarises the model across all thresholds 
  ]
]
#slide(title: "Receiver Operating Characteristic")[
  #align(center)[#image("pics/ROCbing.png")]
]

#slide(title: "Quadratic Discriminant Analysis")[
  - For LDA, we assume that $(X|Y=k) tilde  N(mu_k, Sigma)$.
  - For QDA, we assume that $(X|Y=k) tilde  N(mu_k, Sigma_k)$. Then we cannot cancel the common factor of $x^T Sigma^(-1) x\/2$, which means the discriminant is quadratic:
  $
  delta_k (x) 
    &= - 1/2 (x-mu_k)^T Sigma_k^(-1) (x-mu_k) - 1/2 log|Sigma_k|  + log pi_k \
    &= - 1/2 x^T Sigma_k^(-1) x + x^T Sigma_k^(-1) mu_k   - 1/2 mu_k^T Sigma_k^(-1) mu_k - 1/2 log|Sigma_k|  + log pi_k
  $
  - LDA is a special case of QDA
  - QDA is more flexible than LDA
  - QDA has low bias, LDA has low variance  
    // - each covariance matrix requires $p(p+1)/2$ parameters estimated.
]
#slide(title: "QDA plot, ISLP page 157")[
  #align(center)[#image(height:80%, "pics/QDA.png")]
]
#slide(title: [QDA plot, ESL 2nd Ed. page 103])[
  #align(center)[#image("pics/QDAESL.png")]
]

#slide[
  = Naïve Bayes
]
#slide(title: "Naïve Bayes")[
  - for LDA or QDA, we assumed $f_k$ was a Gaussian density.
  - for Naïve Bayes, we instead assume:
  #myblock[#align(center)[Within the $k$th class, the $p$ predictors are independent.]]
  i.e. for each $k=1,dots, K$, we assume $f_k$ takes the form:
  $
  f_k (x) = f_(k 1) (x_1) f_(k 2) (x_2) dots.c f_(k p) (x_p).
  $
  - great simplification because how to model the interactions?
    - for MV normal distribution, given by the $p(p-1)/2$ off-diagonal terms of $Sigma$
    - In general, need $n>>1$ to estimate full joint distribution.
  
  $
   arrow.squiggly quad  p_k(x) = (pi_k f_(k 1) (x_1) f_(k 2) (x_2) dots.c f_(k p) (x_p))/(sum_ell pi_ell f_(ell 1) (x_1) f_(ell 2) (x_2) dots.c f_(ell p) (x_p))
  $
]
#slide(title: "Naïve Bayes: Estimation of marginals")[#v(-1em)
  - The easiest thing to do is to assume a parametric form for $f_(k i)$, e.g. Gaussian
    - independence  $ arrow.squiggly f_(k i)$ is the density of some $N(mu,sigma^2 I_p)$ rv. Special case of QDA
  - Non-parametric estimation for quantitative predictor:
    - histograms or "smoothed histograms" i.e. kernel density estimators 
  - qualitative predictors: estimate as proportions. E.g. if 
    -  the $j$th predictor $x_j$ takes values in ${#emoji.pizza, #emoji.burger, #emoji.chocolate }$, and 
    - for the $k$th class we observed $100$ training data points, for which 
    #side-by-side[
      $\#{x_j=#emoji.pizza} &= 32$
    ][
      $\#{x_j=#emoji.burger} &= 55$
    ][
      $\#{x_j=#emoji.chocolate} &= 13$
    ]
    Then we can put
    #v(-1em)
    $
      f_(k j) (x_j) = cases(0.32 "if" x_j=#emoji.pizza,0.55 "if" x_j=#emoji.burger,0.13 "if" x_j=#emoji.chocolate)
    $
]
#slide(title: "Kernel Density Estimators")[
#link("https://en.wikipedia.org/wiki/Kernel_density_estimation")[Wikipedia pics on KDEs]
  #side-by-side(columns: (60%, 37%))[#image("pics/kde.png")][#image("pics/kde2.png")]
]
#slide(title: "Naïve Bayes on the Default-Balance-Student Data")[
  #side-by-side(columns:(50%,50%))[Training confusion matrix, $p_0=0.5$
    #table(
    align: right,
    columns: (auto, auto, auto, auto),
    stroke: none,
    [], [ No], [Yes], [Total], 
    [Pred No], [9621], [244], [9865], 
    [Pred Yes], [46], [89], [135], 
    [Total], [9667], [333], [10,000], 
  )
  $"sensitivity" = 26.7%,\ "total error"=2.9%.$
  ][Training confusion matrix, $p_0=0.2$
    #table(
    align: right,
    columns: (auto, auto, auto, auto),
    stroke: none,
    [], [ No], [Yes], [Total], 
    [Pred No], [9339], [130], [9469], 
    [Pred Yes], [328], [203], [531], 
    [Total], [9667], [333], [10,000], 
  )
  $"sensitivity" = 60.9%,\ "total error"=4.58%.$
  ]
  #v(1em)
  - Performs about the same as LDA: $n=10,000$ and $p=2$.
  - We expect Naïve Bayes to be better when $n$ is small and $p$ is large.
]
#slide(title: "Logistic regression on the Default-Balance-Student Data")[
  #show raw: set text(size: 14pt)
#side-by-side(columns: (55%, 45%))[```python
from ISLP import load_data
from sklearn.metrics import confusion_matrix
from sklearn.linear_model import LogisticRegression

data = load_data("Default")
ny = {"No": 0, "Yes": 1}
for col in ["default", "student"]:
    data.loc[:, col] = data[col].map(ny)
X = data.loc[:,["student", "balance", "income"]]
y = data.loc[:,"default"]
model = LogisticRegression(penalty=None)
model.fit(X, y)
y_pred = model.predict(X)
confusion_matrix(y, y_pred).T 
  ```][Output in notebook: 
```python 
array([[9608,  269],
       [  59,   64]])```
     Threshold $p_0=0.2$:
     
   ```python
y_pred2 = (model.predict_proba(X)[:,1] >= 0.2).astype(bool)
confusion_matrix(y, y_pred2).T
```
Output:
```python
array([[9308,  177],
       [ 359,  156]])```]
]
#slide(title: "Logistic Regression on Default: ROC curve")[
#side-by-side[```bash pip install scikit-plot``` \ or ```bash pdm add scikit-plot``` or ... then```python
import scikitplot as skplt
import matplotlib.pyplot as plt

y_probas = model.predict_proba(X)
skplt.metrics.plot_roc(y, y_probas)
plt.show()
  ```
][
 #image("pics/ROClog.png") 
]
]
#slide[
  #myblock(title: "Summary for Generative Models")[
    - assume a computationally convenient form for the joint distribution by estimating $pi_k = PP(Y=k)$ and $f_k(x) = PP(X=x|Y=k)$.
    - Recover $PP(Y=k|X=x)$ by Bayes' Theorem
    - For LDA, $X|Y=k tilde N(mu_k, Sigma)$: linear boundaries
    - For QDA, $X|Y=k tilde N(mu_k, Sigma_k)$: curved boundaries
      - $mu_k$, $Sigma_k$ can be independently identified or estimated 
    - For Naive Bayes, assume ${X_i|Y=k}_(i=1)^p$ are (mutually) independent.
  ]
  
  #myblock(title: "Tuning for sensitivity / specificity")[
    - Adjust decision boundary by changing the threshold values
    - e.g. if $K=2$ then can classify to class 2 if $PP(Y=k|X=x) > t in[0,1]$
    - Will increase overall error but can improve false pos/negative rate
    - Consult ROC curve for sweetspot, AUC to evaluate model
  ]
]
#new-section-slide("Comparison of Classification Methods")
#slide(title: [Formula for log probability ratios])[
  For each classification method, we will compare $
  op("lr")(x) := log PP(Y=k | X=x)/PP(Y=K | X=x) = log (pi_k f_k (x))/(pi_K f_K (x)). 
  $
  - We have $op("lr")_"LDA" (x) = a_k + b_k x$ for some $a_k, b_k$, like $op("lr")_"log" (x)$, 
  - $op("lr")_"QDA" (x) = a_k + b_k x + x^T C_k x$.
  - Naïve Bayes: 
  #v(-2em)
  $
  op("lr")_"NB" (x) & = log (pi_k product_(j=1)^p f_(k j) (x_j))/(pi_K product_(j=1)^p f_(K j) (x_j)) \
  &= log pi_k/pi_K + sum_(j=1)^p log (f_(k j) (x_j))/(f_(K j) (x_j)) = a_k + sum_(j=1)^p g_(k j) (x_j)
  $
  - So Naïve Bayes takes the form of an Generalised Additive Model (GAMs: Chapter 7)
]
#slide(title: [Comparison of classification methods])[
  #side-by-side(columns: (37%, 60%))[
  -  $op("lr")_"LDA" (x) = a_k + b_k x = op("lr")_"log" (x)$, 
  - $op("lr")_"QDA" (x) = a_k + b_k x + x^T C_k x$.
  - $op("lr")_"NB" (x) = a_k + sum_(j=1)^p g_(k j) (x_j)$.
  ][ 
    #set list(marker: ("-",$arrow.squiggly$))
    - LDA is a special case of QDA
    - $op("lr")$ of any classifier with linear boundaries \ 
      has the form $op("lr")_"NB"$
      - LDA is a special case of NB
      // TODO: rewatch this part of the lectures
    - QDA with diagonal $Sigma$ is a special case of NB
    - generally, $op("lr")_"QDA" != op("lr")_"NB"$
      - QDA can have interaction terms.
    - $op("lr")_"LDA" (x) = op("lr")_"log" (x)$ but classifier is trained differently based on different assumptions.
      - LDA should be better when the normality assumption holds, LR otherwise
  ]
]
#slide(title: [Comparison with KNN])[
  #set list(marker: ("-",$arrow.squiggly$))
  - KNN is non-parametric and flexible. 
    - Should be best when boundaries are highly nonlinear
    - requires a lot of data
    - If boundary is nonlinear but data is small, consider QDA
    - Logistic regression gives coefficients (interpretation)
]
  // $
  // p_k (x) 
  //   = (pi_k 1/sqrt(2 pi sigma^2) exp(- 1/(2 sigma^2)(x-mu_k)^2) )
  //   / (sum_(l=1)^K pi_l 1/sqrt(2 pi sigma^2) exp(- 1/(2 sigma^2)(x-mu_l)^2))
  // $
#slide(title: [Simple empirical tests 1,2,3 ($K=2$)])[
  Different methods on 100 random training sets
  #side-by-side(columns: (69%,30%) )[#image("pics/emp123.png")][
    + $n=20$, \ uncorrelated gaussians
    + $n=20$, $"corr"_(k=1,2)=1\/2$
    + $n=50$, $"corr"_(k=1,2)=1\/2$, \ drawn from $t$ dist.
  ]
]
#slide(title: [Simple empirical tests 4,5,6 ($K=2$)])[
  #side-by-side(columns: (20%,70%) )[
    4. $n=20$,
    $"corr"_(k=1) &= 1\/2$\
    $"corr"_(k=2) &= -1\/2$
  ][#image("pics/emp456.png")]
 
    5. #text(font: "Allura",size: 30pt)[Highly nonlinear distribution]
    6. $n=6$, $(X|Y=k) tilde N(mu_k, sigma_k^2 I)$
  
]
#new-section-slide("Generalised Linear Models")
#set list(marker: ("🚲"))
#slide(title: [The `Bikeshare` dataset])[
  - Response: number of $#[`bikers`] in ZZ_(>=0)$.
    
    // + $#[`workingday`] in {"Yes", "No"}$, 
    // + $#[`temp`] in RR$,
    // + #v(-1em) $#[`weathersit`] in {#box(baseline: 1.5em )[ "cloudy", "misty", \ "light rain", "heavy rain",\ "light snow", "heavy snow"]}$. #v(1em)
    #show "ISLP_": _ => {"ISLP"}
   ```python
  from ISLP import load_data 
  > Bike = load_data('Bikeshare') 
  > Bike.shape, Bike.columns 
  ((8645, 15), Index(['season', 'mnth', 'day', 'hr', 'holiday', 'weekday', 'workingday', 'weathersit', 'temp', 'atemp', 'hum', 'windspeed', 'casual', 'registered', 'bikers'], dtype='object')) ```
  - Linear regression has similar issues to classification:
    - negative `bikers`?
    - fractional `bikers`?
  
]
#slide(title: "Heteroskedasticity")[
  - In addition, data is heteroskedastic:
  #align(center)[#image(height:80%, "pics/bikers.png")]
]
#set list(marker: ("🐟"))
#slide(title: [Poisson Regression #incline])[
  // #myblock[#align(center)[Idea: apply a transform like in logistic regression.]]
  - A standard distribution on $ZZ_(>=0)$ to model counts is the Poisson distribution: let $lambda>0$. We say $N tilde op("Poi")(lambda)$ if $PP(N = k) = e^(-lambda) lambda^k/k!$ for $k=0,1,2,dots,$ and $PP(N = k)=0$ otherwise. 
  - Note $EE N = op("Var") N = lambda$ (models heteroskedasticity)
  - Modelling assumption:
  $
    Y|X tilde op("Poi")(lambda(X)), quad quad lambda(X) = exp(X beta).
  $
  - Use MLE approach, i.e. choose $beta$ to maximise
  $
    ell(beta) = product_(j=1)^n e^(-lambda(x_i)) lambda(x_i)^(y_i) / (y_i !).
  $
]
#set list(marker: $bullet$)
#slide(title: [Linear, Logistic and Poisson as Generalised Linear Models])[
  - assume $Y|X$ belongs to some family of distributions
  - use a *link function* $eta$ so that  $eta(EE(Y|X)) = X beta$
  - Fit by MLE estimation.
  #myblock[
  #grid(
    columns: (23%, 15%, 20%, 15%),
    // align: (right, left, left, left),
    gutter: 1em,
    column-gutter: 1em,
    align(right)[*Regression \ type*],[Linear],[Logistic],[Poisson],
    align(right)[$bold(Y|X)$], [Gaussian], [Bernoulli], [Poisson],
    align(right)[*link \ function*], [$eta(y)=y$],[$eta(y)=op("logit")y$],[$eta(y)=log y$]
)]

]