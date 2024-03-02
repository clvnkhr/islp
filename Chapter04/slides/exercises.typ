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

#show "Confounding": name => {emoji.warning + text(font: "Permanent Marker",name) + emoji.warning}

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

#let question(title: "", body) = myblock(title: title, fill: gradient.linear(red.lighten(90%),orange.lighten(90%)), title-fill: gradient.linear(red.darken(10%),orange.darken(10%)), width: 95%, body)

#let answer(body) = {[*Answer* ] + text(fill: green.darken(50%), body)}

#let incline = {box(baseline: -0.3em)[#image(height:1em,"pics/road.svg")]}

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// SLIDES BEGIN NOW !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

#title-slide(
  title: "Classification Exercises",
  subtitle: [Slides on _Introduction to Statistical Learning_, Chapter 4],
  author: [Calvin Khor],
  date: [January 2024],
  // extra: [test]
)

////////////////////
//// EXERCISES!!!!
////////////////////
// #new-section-slide("Exercises")

#slide[
  #question(title: "Exercise 1 (paraphrased)")[
    Prove that:
  $
    p(X) &= e^(beta_0 + beta_1 X) / (1 + e^(beta_0 + beta_1 X)) <==>
    p(X) / (1 - p(X)) &= e^(beta_0 + beta_1 X)
  $
  ]
  #answer[
    This follows once we show that $f: (0,oo) -> (0, 1), thin f(t) = t/(1+t)$ has the inverse $g(s) = s/(1-s)$. Since $f(t) = 1 - 1/(1+t)$, it is monotonic and has an inverse.
    To finish we simply compute
    $
      f(t)(1+t) = t <==> f(t) = t(1-f(t)) <==> f(t)/(1-f(t)) = t <==> g compose f(t) = t.
    $
  // $ 
  //   &&p(X) &= e^(beta_0 + beta_1 X) / (1 + e^(beta_0 + beta_1 X))\
  //   &<==> &p(X) (1 + e^(beta_0 + beta_1 X)) &= e^(beta_0 + beta_1 X)\
  //   &<==>&p(X) &= e^(beta_0 + beta_1 X) (1 - p(X))\
  //   &<==> &p(X) / (1 - p(X)) &= e^(beta_0 + beta_1 X)
  // $
]
]
#slide[
  #question(title: "Exercise 2 (paraphrased)")[
    Prove that in LDA, the class with the largest posterior is the class with the largest discriminant.
  ]
  #answer[
  Already did this. 
  ]
]

#slide[
  #v(-1em)
  #question(title: "Exercise 3 (paraphrased)")[
    Suppose that we have $K>=1$ classes and if the observation comes from class $k$, then $X tilde N(mu_k, sigma_k^2)$. Show that the Bayes classifier is not linear, and in fact it is quadratic.
  ]
  #answer[
    The Bayes classifier is the ideal classifier that chooses 
    the class with the largest conditional probability given the observation, i.e. $op(limits: #true, "argmax")_k PP(Y=k|X)$. 
    We are given $X|Y tilde N(mu_k, sigma_k^2)$, so that in the earlier notation, $f_k (x) = (2 pi sigma^2_k)^(-1/2) e^(-(x-mu_k)^2/(2sigma_k^2))$. 
    
    Recall $p_k (x)= (pi_k f_k (x))/(sum_ell pi_ell f_ell (x))$. Since the denominator does not depend on $k$, and since $log$ is increasing, $p_k (x)$ is maximised iff $log pi_k - (x-mu_k)^2/(2sigma^2_k) - log sigma_k$ is maximised.
  
    The boundary between two classes $k,k'$ is nonlinear when $sigma_k != sigma_(k')$ since it is given by the solutions to
    $
    log pi_k - (x-mu_k)^2/(2sigma^2_k) - log sigma_k = log pi_(k') - (x-mu_(k'))^2/(2sigma^2_(k')) - log sigma_(k').
    $
  ]
]
#set enum(numbering: "(a)")
#slide[
    #question(title: "Exercise 4 (not paraphrased)")[
      When the number of features p is large, there tends to be a deterioration in the performance of KNN and other local approaches that perform prediction using only observations that are near the test observation for which a prediction must be made. This phenomenon is known as the curse of dimensionality, and it ties into the fact that non-parametric approaches often perform poorly when p is large. We will now investigate this curse. 
      1. Suppose that we have a set of observations, each with measurements on $p = 1$ feature, $X$. We assume that $X$ is uniformly (evenly) distributed on $[0, 1]$. Associated with each observation is a response value. Suppose that we wish to predict a test observation’s response using only observations that are within $10 %$ of the range of $X$ closest to that test observation. For instance, in order to predict the response for a test observation with $X = 0.6$, we will use observations in the range $[0.55, 0.65]$. On average, what fraction of the available observations will we use to make the prediction? #uncover(2)[#answer[$10%$]]
  ]
]
#slide[
  #question(title: "Exercise 4 (not paraphrased...)")[
    2. Now suppose that we have a set of observations, each with measurements on $p = 2$ features, $X_1$ and $X_2$. We assume that $(X_1, X_2)$ are uniformly distributed on $[0, 1] × [0, 1]$. We wish to predict a test observation’s response using only observations that are within $10 $% of the range of $X_1$ and within $10 %$ of the range of $X_2$ closest to that test observation. For instance, in order to predict the response for a test observation with $X_1 = 0.6$ and $X_2 = 0.35$, we will use observations in the range $[0.55, 0.65]$ for $X_1$ and in the range $[0.3, 0.4]$ for $X_2$. On average, what fraction of the available observations will we use to make the prediction? #uncover((2,3))[#answer[$1%$.]]
    3. Now suppose that we have a set of observations on $p = 100$ features. Again the observations are uniformly distributed on each feature, and again each feature ranges in value from $0$ to $1$. We wish to predict a test observation’s response using observations within the $10 %$ of each feature’s range that is closest to that test observation. What fraction of the available observations will we use to make the prediction? \ #only(3)[#answer[$(10%)^100 = 0.underbrace(000 dots.c 0, "99")1$.]]
  ]
]
#slide[
  #question(title: [Exercise 4 (not paraphrased......#only(3)[💦])])[
  4. Using your answers to parts (a)–(c), argue that a drawback of KNN when $p$ is large is that there are very few training observations “near” any given test observation. \
    #uncover((2,3 ))[#answer[When $p$ is large, the $K$ nearest neighbors may not be very similar to the test observation, and their outputs may not be representative of the true output.]]
    
  5. Now suppose that we wish to make a prediction for a test observation by creating a $p$-dimensional hypercube centered around the test observation that contains, on average, $10 %$ of the training observations. For $p = 1$, $2$, and $100$, what is the length of each side of the hypercube? Comment on your answer. \
    _ Note: A hypercube is a generalization of a cube to an arbitrary number of dimensions. When $p = 1$, a hypercube is simply a line segment, when $p = 2$ it is a square, and when $p = 100$ it is a $100$-dimensional cube._\ 
     #uncover(3)[
       #answer[ 
        The volume of a hypercube with sidelength $ell$ is $ell^p$. To equal $10%$, we therefore need
         $ell = (10%)^(1\/p)$. 
         For $p=100$, 
         $ell = #{str(calc.pow(0.1,0.01)).slice(0,5)}$
         which is basically the whole space.
       ]  
     ]
  ]
]

#slide[
  #question(title: "Exercise 5")[
    We now examine the differences between LDA and QDA. 
    + If the Bayes decision boundary is linear, do we expect LDA or QDA to perform better on the training set? On the test set? #uncover("2-")[#answer[training: QDA, test: LDA]]
    + If the Bayes decision boundary is non-linear, do we expect LDA or QDA to perform better on the training set? On the test set? #uncover("3-")[#answer[training: QDA, test: QDA]]
    + In general, as the sample size n increases, do we expect the test prediction accuracy of QDA relative to LDA to improve, decline, or be unchanged? Why? \ #uncover("4-")[#answer[Improve, as QDA is more flexible so needs more data.  Also in applications the true boundary will not be perfectly linear.]]
    + True or False: Even if the Bayes decision boundary for a given problem is linear, we will probably achieve a superior test error rate using QDA rather than LDA because QDA is flexible enough to model a linear decision boundary. Justify your answer. 
      #uncover(5)[#answer[
      Yes but only if the training set is large enough
If your training set is not large enough then this will not be the case due to overfitting
    ]]
  ]
]

#slide[
  #question(title: "Exercise 6")[
    #let sigmacalc(x) = {
      calc.exp(x)/(1+calc.exp(x))
    }
    #let logitcalc(x) = {
      calc.log(x/(1-x))
    }
    #v(-0.5em) Suppose we collect data for a group of students in a statistics class with variables $X_1 = "hours studied", X_2 = "undergrad GPA", "and" Y = "receive an A"$. We fit a logistic regression and produce estimated coefficient, $hat(β)_0 = −6, hat(β)_1 = 0.05, hat(β)_2 = 1$. 
    + Estimate the probability that a student who studies for $40$ h and has an undergrad GPA of $3.5$ gets an A in the class. \
      #uncover("2-")[
        #answer[#v(-0.7em)
          $
          PP lr((Y mid(|)X=vec(1,40,3.5)))=sigma( vec(-6,0.05,1) dot.c vec(1,40,3.5)) 
          = #{sigmacalc(-6 * 1 + 0.05 * 40 + 1 * 3.5)}...
          approx 38%.
          $
        ]
      ]
    + How many hours would the student in part (a) need to study to have a $50 %$ chance of getting an A in the class? \
      #uncover("3-")[
        #answer[#v(-0.7em)
          $
            vec(-6,0.05,1) dot.c vec(1,h,3.5) = sigma^(-1)(1/2) 
            => h =  20 times (sigma^(-1)(1/2) + 6 - 3.5)
            =  #{20 * (logitcalc(1/2) + 6 - 3.5)} "hours".
          $#v(-0.7em)
        ]
      ]
  ]
]

#slide[

  #question(title: "Exercise 7")[
    Suppose that we wish to predict whether a given stock will issue a dividend this year (“Yes” or “No”) based on $X$, last year’s percent profit. We examine a large number of companies and discover that the mean value of $X$ for companies that issued a dividend was $overline(X) = 10$, while the mean for those that didn’t was $overline(X) = 0$. In addition, the variance of $X$ for these two sets of companies was $hat(σ)^2 = 36$. Finally, $80 %$ of companies issued dividends. Assuming that $X$ follows a normal distribution, predict the probability that a company will issue a dividend this year given that its percentage profit was $X = 4$ last year. 
  ]
  #uncover(2)[
    #answer[
        #let norm(x, mu, var) = {
          let z = - (x - mu) * (x - mu) / (2 * var)
          let c = calc.sqrt(2 * calc.pi * var) 
          calc.exp(z)/c
        }
      Given: $X|"Yes" tilde N(10,36), X|"No" tilde N(0, 36)$ and $pi_"Yes" = 0.8$. Then
      $
        p_"Yes" 
        = (pi_"Yes" f_("Yes")(x))/(sum_(ell in {"Yes", "No"}) pi_ell f_ell (x))
        = #{
          0.8 * norm(4,10,36) / (0.8 * norm(4,10,36) + 0.2 * norm(4,0,36))
        }
        ... approx 75.2%.
      $.
    ]
  ]
]

#slide[
  #question(title: "Exercise 8")[
    Suppose that we take a data set, divide it into equally-sized training and test sets, and then try out two different classification procedures. First we use logistic regression and get an error rate of $20 %$ on the training data and $30 %$ on the test data. Next we use $1$-nearest neighbors (i.e. $K = 1$) and get an average error rate (averaged over both test and training data sets) of $18 %$. Based on these results, which method should we prefer to use for classification of new observations? Why? 
  ]
  #uncover("2-")[
    #answer[
     Logistic regression.
     #uncover("3-")[
       Recall that $1$NN performs perfectly on the train data. So an average error of $18%$ is really a $36%$ error rate on the test set, while we are given logistic has a $30%$ error rate.
     ]
    ]
  ]
]

#slide[
  #question(title: "Exercise 9")[
    This problem has to do with odds. 
    + On average, what fraction of people with an odds of $0.37$ of defaulting on their credit card payment will in fact default? 
    + Suppose that an individual has a $16 %$ chance of defaulting on her credit card payment. What are the odds that she will default? 
  ]
  #uncover("2-")[#answer[
     $omega = p/(1-p)$ 
    // iff $omega-omega p = p$ iff $omega = p(1+omega)$ 
    iff $p = omega/(1+omega)$. #uncover("3-")[So
    + $p = (0.37)/(1+0.37) = #{(0.37)/(1+0.37)} ... approx 27%$
    + $omega = (0.16)/(1-0.16) = 4/21 = 4:21 "odds" approx 1 : 5 "odds".$]
  ]]
]

#slide[
  #v(-0.5em)
  #question(title: "Exercise 10")[
    #v(-0.5em)
    Equation $(4.32)$ derived an expression for $log PP(Y =k|X=x) / PP(Y =K|X=x)$ in the setting where $p > 1$, so that the mean for the $k$th class, $mu_k$, is a $p$ dimensional vector, and the shared covariance $Σ$ is a $p × p$ matrix. However, in the setting with $p = 1$, ($4.32$) takes a simpler form, since the means $mu_1, dots , mu_K$ and the variance $σ^2$ are scalars. In this simpler setting, repeat the calculation in ($4.32$), and provide expressions for $a_k$ and $b_(k j)$ in terms of $π_k, π_K, mu_k, mu_K,$ and $σ^2$.
  ]
  #answer[
    equation (4.32) is #v(-0.5em)
    $
      log PP(Y =k|X=x) / PP(Y =K|X=x) = log pi_k/pi_K - 1/2 (mu_k + mu_K)^T Sigma^(-1) (mu_k - mu_K) + x^T Sigma^(-1)(mu_k - mu_K)
    $
    #v(-0.5em)
    Since the above formula is valid for all $p>=1$, we can just substitute $p=1$ and simplify to get:
    $
      log PP(Y =k|X=x) / PP(Y =K|X=x) 
      = underbrace(
          log pi_k/pi_K - (mu_k^2 - mu_K^2)/(2sigma^2), 
          a_k
        ) + underbrace(
          ((mu_k - mu_K) )/sigma^2, 
          b_(k  1)
        ) x.
    $
  ]
]

#slide(use-content-equation-text-size: false)[
  #question(title: "Exercise 11")[
    #show math.equation: set text(size: 21pt) 
    Work out the detailed forms of $a_k, b_(k j)$, and $b_(k j l)$ in (4.33). Your answer should involve $π_k, π_K, mu_k, mu_K, Σ_k,$ and $Σ_K$.
  ]
  #answer[ #[ 
  #show math.equation: set text(size: 21pt)  
  recall $f_k (x) = 1/((2 pi)^(n/2) |Sigma_k|^(1/2)) exp( (-1)/2 (x-mu_k)^T Sigma_k^(-1) (x-mu_k))$. So]
  #show math.equation: set text(size: 19pt)  
    $ 
      &log PP(Y =k|X=x) / PP(Y =K|X=x)  
      = log (pi_k f_k (x))/(pi_K f_K (x)) \
      &= log pi_k/pi_K 
        - 1/2 log (|Sigma_k|)/(|Sigma_K|) 
        - 1/2 (x-mu_k)^T Sigma_k^(-1) (x-mu_k) 
        + 1/2 (x-mu_k)^T Sigma_K^(-1) (x-mu_k)  \ 
      &= log pi_k/pi_K 
        - 1/2 log (|Sigma_k|)/(|Sigma_K|) 
        - 1/2 mu_k^T Sigma_k^(-1) mu_k 
        + 1/2 mu_K^T Sigma_K^(-1) mu_K 
        +  x^T Sigma_k^(-1) mu_k 
        - x^T Sigma_K^(-1) mu_K 
        - 1/2 x^T (Sigma_k^(-1) - Sigma_K^(-1))x\
      &= log pi_k/pi_K 
        - 1/2 log (|Sigma_k|)/(|Sigma_K|) 
        - 1/2 mu_k^T Sigma_k^(-1) mu_k 
        + 1/2 mu_K^T Sigma_K^(-1) mu_K 
        +  x^T (Sigma_k^(-1)mu_k - Sigma_K^(-1) mu_K) 
        - 1/2 x^T (Sigma_k^(-1) - Sigma_K^(-1))x
    $
    To make it similar to (4.32) we could put $Sigma_plus.minus^(-1) = (Sigma_k^(-1) plus.minus Sigma_K^(-1))/2$ so that $Sigma_k^(-1) = Sigma_+^(-1) + Sigma_-^(-1)$ and $Sigma_K^(-1) = Sigma_+^(-1) - Sigma_-^(-1)$. Then 
    // $
    // -k (p+m) k + K (p-m) K
    // = -k p k + K p K - k m k - K m K 
    // $ 
    $"RHS of previous page" =$ 
    $
      &= log pi_k/pi_K 
        - 1/2 log (|Sigma_k|)/(|Sigma_K|) 
        - 1/2 mu_k^T Sigma_k^(-1) mu_k 
        + 1/2 mu_K^T Sigma_K^(-1) mu_K 
        +  x^T (Sigma_k^(-1)mu_k - Sigma_K^(-1) mu_K) 
        - 1/2 x^T (Sigma_k^(-1) - Sigma_K^(-1))x\
        &= log pi_k/pi_K 
        - 1/2 log (|Sigma_k|)/(|Sigma_K|) - 1/2 (mu_k+mu_K)^T Sigma_+^(-1) (mu_k-mu_K) - 1/2 mu_k Sigma_-^(-1) mu_k - 1/2 mu_K Sigma_-^(-1) mu_K \
        // &quad +  x^T (Sigma_k^(-1)mu_k - Sigma_K^(-1) mu_K)\
        &quad + thin   x^T Sigma_+^(-1)(mu_k - mu_K) + x^T Sigma_-^(-1)(mu_k + mu_K)\
        &quad - thin x^T Sigma_-^(-1) x.
    $
    Now when $Sigma_k = Sigma_K =: Sigma$ then $Sigma_+ = Sigma $ and $Sigma_- = 0$, recovering (4.32).
  ]
]

#let orange = [🍊]
#let apple = [🍎]
// #let orange = raw("orange")
// #let apple = raw("apple")

#slide[
  #question(title: "Exercise 12")[
    Suppose that you wish to classify an observation 
    $X ∈ RR$ into #[#apple]s and #[#orange]s. You fit a logistic regression model and find that 
    $
    hat(PP)(Y = #orange |X = x) = exp(hat(beta)_0 + hat(beta)_1x)/(1 + exp(hat(beta)_0 + hat(beta)_1x)).
    $ 
    Your friend fits a logistic regression model to the same data using the softmax formulation in (4.13), and finds that 
    #only("-2")[$
    hat(PP)(Y = #orange|X = x) = exp(hat(alpha)_(#orange 0) + hat(alpha)_(#orange 1)x) /(exp(hat(alpha)_(#orange 0) + hat(alpha)_(#orange 1)x) + exp(hat(alpha)_(#apple 0) + hat(alpha)_(#apple 1)x)).
    $]
    #only("3-")[$
    hat(PP)(Y = #orange|X = x) = exp((hat(alpha)_(#orange 0) - hat(alpha)_(#apple 0)) + (hat(alpha)_(#orange 1) - hat(alpha)_(#apple 1))x) /( 1 + exp((hat(alpha)_(#orange 0) - hat(alpha)_(#apple 0)) + (hat(alpha)_(#orange 1) - hat(alpha)_(#apple 1))x)).
    $]
    + What is the log odds of orange versus apple in your model? #uncover("3-")[#answer[$hat(beta)_0 + hat(beta)_1x$]]
    + What is the log odds of orange versus apple in your friend’s model? \
      #uncover("3-")[#answer[$(hat(alpha)_(#orange 0) - hat(alpha)_(#apple 0)) + (hat(alpha)_(#orange 1) - hat(alpha)_(#apple 1))x$]]

  ]
]

#slide[
  #question(title: "Exercise 12 cont.")[
    3. Suppose that in your model, $hat(beta)_0 = 2$ and $hat(beta)_1 = −1$. What are the coefficient estimates in your friend’s model? Be as specific as possible. \
      #uncover("2-")[#answer[
        By equating the #orange log odds we get
        $hat(alpha)_(#orange 0) - hat(alpha)_(#apple 0) = 2,$ and $hat(alpha)_(#orange 1) - hat(alpha)_(#apple 1) = -1$
        There is no further information that can fix the friend's coefficients: #apple log odds are already fixed as $1-sigma(t)=sigma(-t)$. 
      ]
      ]
    4. $""^#link("https://www.statlearning.com/errata-python-edition")[typo fixed]$Now suppose that you and your friend fit the same two models on a different data set. This time, your friend gets the coefficient estimates $hat(alpha)_(#orange 0) = 1.2$, $hat(alpha)_(#orange 1) = −2$, $hat(alpha)_(#apple 0) = 3$, $hat(alpha)_(#apple 1) = 0.6$. What are the coefficient estimates in your model? \
       #uncover("3-")[ #answer[
         Similarly to the above,
         $hat(beta)_0 = 1.2 - 3 = #{1.2 - 3}$, and $hat(beta)_1 = -2 - 0.6 = #{-2 - 0.6}.$
       ]
    ]
    5. Finally, suppose you apply both models from (d) to a data set with $2,000$ test observations. What fraction of the time do you expect the predicted class labels from your model to agree with those from your friend’s model? Explain your answer. \
       #uncover(4)[#answer[
      Always. Because the log-odds are exactly equal and they define the decision boundaries.
    ]]
  ]
]
#slide(title: [Extra: ESL Exercise 4.2 #emoji.skull])[
#side-by-side[#image("pics/esl1.jpeg")][#image("pics/esl2.jpeg")]
]
#slide(use-content-equation-text-size: false)[
#set text(size: 15pt)
#show math.equation: set text(size: 15pt)
(a) is trivial from knowing the discriminant $delta_k (x) = log pi_k + x^T Sigma^(-1) mu_k - 1/2mu_k^T Sigma^(-1) mu_k$ so lets do (b). First we fix notation. 
  $
  y_i in {-N/N_1, N/N_2} =: {c_1,c_2}, quad  hat(mu)_k = 1/N_k sum_(i: y_i = c_k) x_i, "and"  \
    hat(bold(Sigma)) = 1/(N-2) (sum_(k: y_k = c_1) (x_k - hat(mu)_1)(x_i - hat(mu)_1)^T + sum_(k: y_k = c_2) (x_k - hat(mu)_2)(x_i - hat(mu)_2)^T )
  $
starting from the least squares side. The functional to minimise is $
J(beta_0, beta) 
&= sum_i (y_i - beta_0 - x_i^T beta)^2 = sum_(i: y_i=c_1) (c_1 - beta_0 - x_i^T beta)^2 + sum_(i: y_i = c_2) (c_2 - beta_0 - x_i^T beta)^2 
$
We split the sum because all terms in the identity use the class split. From $diff_beta_0 J=0$ we get
$
   & 0 = sum_(y_i = c_1) (c_1 -hat(beta)_0 - x_i^T hat(beta)) + sum_(y_i = c_2) (c_2 - hat(beta)_0 - x_i^T hat(beta)) \
   <==> & N hat(beta)_0 = N_1 c_1 + N_2 c_2 - (N_1 hat(mu)_1 + N_2 hat(mu)_2)^T hat(beta) \
   <==> & hat(beta)_0 = underbrace(
     (N_1 c_1)/N + (N_2 c_2)/N, =: Delta_1) - (N_1 hat(mu)_1 + N_2 hat(mu)_2)^T/N hat(beta) \
$
for the given class labels $c_1,c_2$ we have that $Delta_1=0$. From $diff_beta J = 0$ we get
$
  & 0 = sum_(y_i = c_1) (c_1 - hat(beta)_0 - x_i^T hat(beta)) x^T_i 
  + sum_(y_i = c_2) (c_2 - hat(beta)_0 - x_i^T hat(beta)) x^T_i \
  <==> & 0 
    = (c_1 - hat(beta)_0) N_1 hat(mu)^T_1 + (c_2 - hat(beta)_0) N_2 hat(mu)^T_2 
    - hat(beta)^T (sum_(y_i = c_1) + sum_(y_i = c_2))  x_i x_i^T \
   <==> & 0 
      = underbrace(
     c_1 N_1 hat(mu)^T_1 + c_2 N_2 hat(mu)^T_2, =: Delta_2^T)
     - hat(beta)_0(N_1 hat(mu)_1 + N_2 hat(mu)_2)^T 
     - hat(beta)^T (sum_(y_i = c_1) + sum_(y_i = c_2))  x_i x_i^T
$ 
Taking the transpose,
$
0 = Delta_2 - hat(beta)_0(N_1 hat(mu)_1 + N_2 hat(mu)_2) - (sum_(y_i = c_1) + sum_(y_i = c_2))  x_i x_i^T hat(beta)
$
For the given class labels, $Delta_2 = N(hat(mu)_2 - hat(mu)_1)$. Notably $Delta_2$ is the RHS of the required identity. Plugging in the formula we found for $hat(beta)_0$:
$
((sum_(y_i = c_1) + sum_(y_i = c_2))  x_i x_i^T - 1/N (N_1 hat(mu)_1 + N_2 hat(mu)_2)(N_1 hat(mu)_1 + N_2 hat(mu)_2)^T  ) beta =  underbrace(Delta_2 - 
 Delta_1 (N_1 hat(mu)_1 + N_2 hat(mu)_2), =: Delta_3)
$
we note that
// $
// (N_1 hat(mu)_1 + N_2 hat(mu)_2)(N_1 hat(mu)_1 + N_2 hat(mu)_2)^T 
// = N_1^2 hat(mu)_1 hat(mu)_1^T + N_2 hat(mu)_2 hat(mu)_2^T + N_1 N_2 (hat(mu)_1 hat(mu)_2^T + hat(mu)_2 hat(mu)_1^T) \
// = sum_(y_i, y_j = C_1) x_i x_j^T +  sum_(y_i, y_j = C_2) x_i x_j^T + sum_(y_i = C_1, y_j = C_2) x_i x_j^T + sum_(y_i = C_2, y_j = C_1) x_i x_j^T
// $
// and that
  $
    hat(bold(Sigma)) 
    = 1/(N-2) (sum_(k: y_k = c_1) (x_k - hat(mu)_1)(x_k - hat(mu)_1)^T + sum_(k: y_k = c_2) (x_k - hat(mu)_2)(x_k - hat(mu)_2)^T ) \ 
    = 1/(N-2) (sum_(k) x_k x_k^T  + N_1 hat(mu)_1 hat(mu)_1^T + N_2 hat(mu)_2 hat(mu)_2^T - 2 N_1 hat(mu)_1 hat(mu)_1^T  - 2 N_2 hat(mu)_2 hat(mu)_2^T)  \ 
  $
so we can write
$
  sum_(k) x_k x_k^T = (N-2) hat(bold(Sigma))  + N_1 hat(mu)_1 hat(mu)_1^T + N_2 hat(mu)_2 hat(mu)_2 ^T.
$ 
also,
$
1/N (N_1 hat(mu)_1 + N_2 hat(mu)_2)(N_1 hat(mu)_1 + N_2 hat(mu)_2)^T 
= N_1^2/N hat(mu)_1 hat(mu)_1^T + N_2/N hat(mu)_2 hat(mu)_2^T + (N_1 N_2)/N (hat(mu)_1 hat(mu)_2^T + hat(mu)_2 hat(mu)_1^T) \
$
so we get out that
$
((N-2) hat(bold(Sigma))  + N_1 hat(mu)_1 hat(mu)_1^T + N_2 hat(mu)_2 hat(mu)_2 ^T 
- N_1^2/N hat(mu)_1 hat(mu)_1^T 
- N_2/N hat(mu)_2 hat(mu)_2^T 
-(N_1 N_2)/N (hat(mu)_1 hat(mu)_2^T + hat(mu)_2 hat(mu)_1^T) )beta & \
= Delta_3&
$
Using that $N_1 + N_2 = N$, we can write $N_1 -N_1^2/N = (N_1 (N - N_1))/N = (N_1 N_2)/N$, ie. that
$
&N_1 hat(mu)_1 hat(mu)_1^T + N_2 hat(mu)_2 hat(mu)_2 ^T 
- N_1^2/N hat(mu)_1 hat(mu)_1^T 
- N_2/N hat(mu)_2 hat(mu)_2^T 
- (N_1 N_2)/N (hat(mu)_1 hat(mu)_2^T + hat(mu)_2 hat(mu)_1^T) \
&= (N_1 N_2)/N (hat(mu)_1 hat(mu)_1^T + hat(mu)_2 hat(mu)_2^T - (hat(mu)_1 hat(mu)_2^T + hat(mu)_2 hat(mu)_1^T) ) \
&= ( N_1 N_2 )/ N ( hat(mu)_2 - hat(mu)_1 )( hat(mu)_2 - hat(mu)_1 )^T \
&=: N hat(bold(Sigma))_B
$
This shows that
$
((N-2)  hat(bold(Sigma)) + N hat(bold(Sigma))_B )hat(beta) = Delta_3
$

To finish, we rewrite the expression for $Delta_3$:
$
  Delta_3 &= Delta_2 - Delta_1 (N_1 hat(mu)_1 + N_2 hat(mu)_2) \
  & = c_1 N_1 hat(mu)_1 + c_2 N_2  hat(mu)_2 - (N_1/N c_1 + N_2/N c_2) (N_1 hat(mu)_1 + N_2 hat(mu)_2) \
  & = c_1 N_1 hat(mu)_1 + c_2 N_2 hat(mu)_2 - N_1^2/N c_1 hat(mu)_1 - N_2^2/N c_2 hat(mu)_2 - (N_1 N_2)/N^2 (c_1 hat(mu)_2 + c_2 hat(mu)_1) \ 
  & = (N_1 N_2)/N^2 ( c_1 hat(mu)_1 + c_2  hat(mu)_2  -  (c_1 hat(mu)_2 + c_2 hat(mu)_1)) \ 
  & = (N_1 N_2)/N^2 (c_1 - c_2) (hat(mu)_1 - hat(mu)_2)
$

We finally arrive at
$
  ((N-2)  hat(bold(Sigma)) + N hat(bold(Sigma))_B )hat(beta) = (N_1 N_2)/N^2 (c_1 - c_2) (hat(mu)_1 - hat(mu)_2)
$
(c) is now trivial; this follows from the fact that $a b^T c = a (b^T c)$ which is a scalar multiple of the vector $a$.

(d) was answered by computing in the above with general $c_(1,2)$.
]
#slide[
(e) let $lambda$ be such that $hat(beta) = lambda bold(Sigma)^(-1) (hat(mu)_1 - hat(mu_2))$. We obtain
$  f(x) = hat(beta)_0 + x^T hat(beta) > 0
  <==> 
  Delta_1  + lambda (x - (N_1 hat(mu)_1 + N_2 hat(mu)_2)/N)^T bold(Sigma)^(-1) (hat(mu)_1 - hat(mu_2)) > 0
$
We see that this is equivalent to LDA iff $(Delta_1)/lambda = log(N_2/N_1)$. In the original labelling (where $Delta_1=0$) this happens iff $N_1 = N_2$.
]

#slide(title:"Extras")[ 
    - #link("https://www.youtube.com/watch?v=wOGBlLLuc4I&list=PLoROMvodv4rNHU1-iPeDRH-J0cL-CrIda&index=9&pp=iAQB")[ISLP python Lab videos on Chapter 4]
    - #link("https://github.com/intro-stat-learning/ISLP_labs/tree/stable")[Link to labs on github]
    - #link("https://intro-stat-learning.github.io/ISLP/labs/Ch04-classification-lab.html")[Link to labs in the ISLP python package documentation]
      - NB also includes more information on the datasets, how to use the package etc.
]