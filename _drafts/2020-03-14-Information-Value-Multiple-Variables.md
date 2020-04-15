---
layout: post
title: "How To Measure Anything - including The Information Values for Multiple Variables"
date: 2020-03-14 12:23:37 -0700
categories: tech
---

## Intro [WIP]

Warning: this blog post more clear if you've read the book

- How To Measure Anything is great
- It suggests measuring the Information Value of variables in a decision model, so that you know where it's worth spending money on refining estimates.
- It gives a great example for a model with one variable...
- but it admits that most models are multi-variate...
- and then steadfastly avoids providing good examples for the multi-variate case!
- I'm going to run through an example.


## The advertising campaign

**TODO:** flesh out.

There is a proposal for an ad campaign which will will cost \$5m to run. If the campaign is rejected, no money is made or spent. If the campaign is accepted, it will run for two market segments, and we may succeed or fail in each segment independently.

In this unrealistic example, we know exactly how much we'll make, but our experts have estimated their chance of success.

|           | Chance of success | Revenue if successful |
|-----------|-------------------|-----------------------|
| Segment A | 60%               | $45m                  |
| Segment B | 90%               | $2m                   |

- **WIP** Objective: figure out which market segment to measure. Spoiler, it's obviously B, but if we can prove that with math, we can apply the technique to harder problems.

## The value of perfect information

**TODO - introduce the following quote. Maybe cut it down**

<!-- > Another more elaborate -- but more accurate -- method starts by running a simulation that shows our expected loss at our current level of uncertainty. I call this the Overall EOL or the Decision EOL. This is simply the average of all outcomes given our current (default) decision assuming we don't measure any further. If, at our current level of uncertainty, our default decision was to reject an investment, but it turns out it would have been a good idea, then the amount we would have made is the opporunity loss in that scenario. In scenarious where our decision turned out to be correct, our opportunity loss was zero. All of these results averaged together -- zeros and non-zero values alike -- is the Overall EOL. -->

> Another more elaborate -- but more accurate -- method starts by running a simulation that shows our expected loss at our current level of uncertainty. I call this the Overall EOL or the Decision EOL. This is simply the average of all outcomes given our current (default) decision assuming we don't measure any further. [...] All of these results averaged together -- zeros and non-zero values alike -- is the Overall EOL.

The book defines Opportunity Loss (OL) as the cost of a bad decision, which could be as much as $5m for this campaign if it completely fails. It goes on to define Expected Opportunity Loss (EOL) as the cost of a bad decision multiplied by its probability.

If the campaign is run, we risk losing money if we don't make as much as the $5m we paid for it.

| A result   | B result   | Profit | Probability | Opportunity Loss<br>(loss if campaign is accepted)
|------------|------------|--------|-------------|------------------
| A succeeds | B succeeds | $42m   | 54%         | $0
| A succeeds | B fails    | $40m   | 6%          | $0 
| A fails    | B succeeds | -$3m   | 36%         | $3m
| A fails    | B fails    | -$5m   | 4%          | $5m


$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& \sum_{\textrm{all scenarios}}{\textrm{Opportunity Loss} * \textrm{Probability}} \\
                         &=& $3m * 36\% + $5m * 4\% \\
                         &=& $1.28m
\end{eqnarray}$$

If the campaign is not run, we can never make any profit, so we risk losing out out on everything we would have made.[^eolname]

**WIP - Note that this calculation is equivalent to a monte-carlo simulation which computes the Overall EOL** 

| A result   | B result   | Profit | Probability | Opportunity Loss<br>(loss if campaign is rejected)
|------------|------------|--------|-------------|------------------
| A succeeds | B succeeds | $0     | 54%         | $42m
| A succeeds | B fails    | $0     | 6%          | $40m
| A fails    | B succeeds | $0     | 36%         | $0
| A fails    | B fails    | $0     | 4%          | $0

$$\begin{eqnarray}
\textrm{EOL if Rejected} &=& \sum_{\textrm{all scenarios}}{\textrm{Opportunity Loss} * \textrm{Probability}} \\
                         &=& $42m * 54\% + $40m * 6\% \\
                         &=& $25.08m
\end{eqnarray}$$

Based on what we know, we should probably decide to run the campaign, because we expect to lose more if we don't than if we do. But just to be safe, shouldn't we spend a bit on a survey to refine our estimate of the chance of failure?

Let's imagine we can buy *perfect information*. We'd definitely do it for $1, and definitely not for $100m. In which case, what's the maximum we should pay? The theory goes that given our current level of uncertainty, we would pay up to $1.28m to confirm that the campaign won't fail. Despite the fact that we might lose up to $5m, any more than $1.28m and we're paying more than the expected value of our loss.

Conversely, if our default option was to reject the campaign, we're throwing away an 'expected' $25.08m, so that's how much we should spend for perfect information on whether it will succeed. If we pay more, we will end up having paid more for the information than we expect to gain.

## The value of information for a single variable

> We then run a series of Monte Carlo Simulations where we pretend we knew one selected variable in the model exactly.

Let's imagine that we get some new information, and now we're 100% confident the campaign will fail in segment A.

| A result   | B result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | B succeeds | $42m   | 0%          | $0                          | $42m                        |
| A succeeds | B fails    | $40m   | 0%          | $0                          | $40m                        |
| A fails    | B succeeds | -$3m   | **90%**     | **$3m**                     | **$0**                      |
| A fails    | B fails    | -$5m   | **10%**     | **$5m**                     | **$0**                      |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $3m &*& 90\% &+& $5m &*& 10\% &=& $3.2m \\
\textrm{EOL if Rejected} &=& $0 &*& 90\% &+& $0 &*& 10\% &=& $0
\end{eqnarray}$$

> We apply a decision rule that tells the model what I would have done differently if I knew only that variable exactly. If knowing this variable was informative, my opportunity losses from making a bad decision (the Overall EOL) should go down.

Armed with this information just about segment A, we would definitely change our decision to reject the campaign proposal, reducing our expected opportunity loss from $1.28m to $0.

We can try the same thing for the case that we learn that segment A is 100% likely to succeed. Noting that this actually reduces the situation to a single variable, we can simplify the table a bit.

| B result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| B succeeds | $42m   | **90%**     | $0                          | **$42m**                    |
| B fails    | $40m   | **10%**     | $0                          | **$40m**                    |


$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $0 \\
\textrm{EOL if Rejected} &=& $42m * 90\% + $40m * 10\% = $41.8m
\end{eqnarray}$$

If we're certain to succeed in segment A then we should definitely run the campaign, because we'll always cover the potential loss of segment B. This too was a very informative piece of information.

Finally, let's consider perfect information about segment B, starting with its failure.

| A result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | $40m   | **60%**     | $0                          | **$40m**                    |
| A fails    | -$5m   | **40%**     | **$5m**                     | $0                          |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $5m &*& 40\% &=& $2m \\
\textrm{EOL if Rejected} &=& $40m &*& 60\% &=& $24m
\end{eqnarray}$$

This doesn't actually change our decision. The campaign is looking a little more risky, but it still looks like a good bet. Here's the final case:

| A result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | $42m   | **60%**     | $0                          | **$42m**                    |
| A fails    | -$3m   | **40%**     | **$3m**                     | $0                          |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $5m &*& 40\% &=& $1.2m \\
\textrm{EOL if Rejected} &=& $40m &*& 60\% &=& $25.2m
\end{eqnarray}$$

If we learn with full confidence that B will succeed, our Expected Opportunity Loss is reduced by $80,000. We wouldn't change our decision, but we might pay up to $80,000 for perfect information on B.

## Knowing what to measure

**WIP**

- this was a simple example
- it still demonstrates that P(success of B) is the most valuable estimate to refine
- when a model consists of a sum of variables, the variable with the widest range is always going to be the most informative
- but in more complex models:
    - it won't always be a sum of variables
    - it may be that no single variable is informative

## Decision rules, loss functions

**WIP**

- "Decision rule" selects from decisions based on their EOL
- Could just take the decision with the lowest EOL, but not always
- You might be more sensitive to actual loss than to lost potential gain.
- e.g. might have a cap on maximum actual loss (a budget), but not a cap on lost potential gain.

## Realistic decisions

**WIP**

- Application to ranges of variables and decisions would follow the same principle
    - Hold a variable (or group of variables) at a single value
    - Simulate the others & compute EOLs of resulting decisions.
    - Compute EOL for 


## Interlude: does any of this actually make sense?

**WIP - worth including?**

### Linear loss versus maximum loss

The concept of paying **[WIP finish this sentence]**, and ultimately it's a pretty simple model of risk. Perhaps we think that we should spend up to $5m because there's *some chance* we could lose that much. That would be the **Maximum** Opportunity Loss, and perhaps it sounds like a good idea, but it falls apart for slimmer probabilities. For example, if we introduce a 0.001% chance of a massive PR disaster which costs $500m in lost sales, should we spend $500m to test the advertisement for PR issues? Probably not! The linear model (for this single variable) suggests $5,000 which seems much more reasonable.

[^eolname]: When you realize that loss can including *losing out*, I think that it makes the name Expected **Opportunity** Loss more clear.

### Uncalibrated estimates

**TODO** something about how the model falls apart if you begin with uncalibrated estimates.