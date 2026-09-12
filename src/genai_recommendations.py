from pathlib import Path

from ollama import chat

from churn_evidence import evidence


def build_recommendation_prompt(evidence):

    prompt = f"""
You are a senior customer-retention strategist.

You are given validated churn-analysis results from a telecom customer
dataset.

Your job is to use these results to generate THREE practical,
testable retention strategies.

IMPORTANT:
The dataset tells us WHICH customer groups have higher observed churn.
It does NOT tell us WHY they churn.

Do not invent reasons for churn.

============================================================
VALIDATED EVIDENCE
============================================================

Overall:
- Total customers: {evidence["overall"]["total_customers"]}
- Overall churn rate: {evidence["overall"]["overall_churn_rate"]}%

Strongest observed segments:

- Month-to-month + Fiber optic: 54.61% churn
- Month-to-month + Electronic check: 53.73% churn
- 0–12 months tenure: 47.44% churn
- Electronic check: 45.29% churn
- No Online Security: 41.77% churn
- No Tech Support: 41.64% churn

Risk-factor analysis:

- 0 observed characteristics: 1.92% churn
- 1 observed characteristic: 6.28% churn
- 2 observed characteristics: 15.05% churn
- 3 observed characteristics: 23.00% churn
- 4 observed characteristics: 40.02% churn
- 5 observed characteristics: 58.13% churn
- 6 observed characteristics: 74.45% churn

The six observed characteristics are:

1. Month-to-month contract
2. Fiber optic internet
3. Electronic check
4. No Online Security
5. No Tech Support
6. Tenure <= 12 months

============================================================
YOUR OBJECTIVE
============================================================

Generate EXACTLY 3 retention strategies.

Each strategy must be a BUSINESS INTERVENTION that the company
could TEST.

Do not simply describe the churn finding again.

The strategy should follow this logic:

OBSERVED PATTERN
      ↓
TARGET SEGMENT
      ↓
PROPOSED INTERVENTION
      ↓
HYPOTHESIS
      ↓
EXPERIMENT
      ↓
MEASUREMENT

============================================================
STRATEGY SELECTION
============================================================

Use these three areas as the foundation:

1. Month-to-month + Fiber optic customers
2. Month-to-month + Electronic check customers
3. Customers in their first 12 months

These are deliberately provided as the primary target areas.

You may design different interventions for each.

DO NOT create a fourth target by combining characteristics that were
not provided together in the evidence.

============================================================
OUTPUT FORMAT
============================================================

For each strategy use EXACTLY this format:

## Strategy 1 — [short strategy name]

**Priority:** 1

**Target Segment:**  
[exact target segment]

**Observed Evidence:**  
State the supplied churn percentage and explain why this segment
is worth testing. Do not add any new statistics.

**Recommended Intervention:**  
Describe ONE specific retention intervention.

**Business Actions:**
1. [specific action]
2. [specific action]
3. [specific action]
4. [specific action]

**Hypothesis:**  
State what the business is testing and use the words
"hypothesis" or "hypothesis to test".

**Experiment Design:**  
Explain how the business could compare customers exposed to the
intervention with an appropriate comparison/control group.

**Success Metrics:**
1. [metric]
2. [metric]
3. [metric]

**Assumptions / Limitations:**  
State what the dataset does not tell us and what would need to be
validated before implementing the intervention.


## Strategy 2 — [short strategy name]

**Priority:** 2

**Target Segment:**  
[exact target segment]

**Observed Evidence:**  
Use only the supplied evidence.

**Recommended Intervention:**  
Describe ONE specific retention intervention.

**Business Actions:**
1. [specific action]
2. [specific action]
3. [specific action]
4. [specific action]

**Hypothesis:**  
Clearly label it as a hypothesis.

**Experiment Design:**  
Describe a test/control comparison.

**Success Metrics:**
1. [metric]
2. [metric]
3. [metric]

**Assumptions / Limitations:**  
State limitations without inventing facts.


## Strategy 3 — [short strategy name]

**Priority:** 3

**Target Segment:**  
[exact target segment]

**Observed Evidence:**  
Use only the supplied evidence.

**Recommended Intervention:**  
Describe ONE specific retention intervention.

**Business Actions:**
1. [specific action]
2. [specific action]
3. [specific action]
4. [specific action]

**Hypothesis:**  
Clearly label it as a hypothesis.

**Experiment Design:**  
Describe a test/control comparison.

**Success Metrics:**
1. [metric]
2. [metric]
3. [metric]

**Assumptions / Limitations:**  
State limitations without inventing facts.

============================================================
CRITICAL RULES
============================================================

RULE 1:
NEVER invent statistics.

Only use the exact percentages supplied above.

RULE 2:
NEVER claim causation.

Never say:

"customers churn because..."
"fiber causes churn"
"electronic checks cause churn"
"customers leave because..."
"customers want..."

Instead say:

"the segment shows elevated observed churn"
"this pattern is worth testing"
"the hypothesis is that..."

RULE 3:
Do not assume WHY a customer churns.

For example:

BAD:
"Customers without tech support churn because they need more help."

GOOD:
"The segment has elevated observed churn. One hypothesis worth
testing is whether a targeted support intervention improves retention."

RULE 4:
Do not automatically recommend a product merely because the customer
does not currently have that product.

For example, do NOT assume:

No Online Security → sell security
No Tech Support → give tech support

The intervention must be framed as a TESTABLE business hypothesis.

RULE 5:
Do not invent customer preferences.

Do not say customers prefer:
- flexibility
- discounts
- security
- support
- lower prices
- longer contracts

unless clearly framed as something being tested.

RULE 6:
Do not invent company capabilities.

Do not assume the company already has:
- loyalty programs
- dedicated teams
- special software
- specific offers
- special pricing
- additional products

You may propose them as potential interventions to test.

RULE 7:
Do not create arbitrary numeric targets.

Never write:

"reduce churn by 15%"
"increase retention by 20%"
"increase satisfaction by 30%"

Instead use measurable outcomes such as:

- churn rate of the targeted group
- retention rate
- offer acceptance rate
- contract conversion rate
- intervention uptake
- churn difference between test and control groups

RULE 8:
Every strategy MUST contain exactly four concrete business actions.

RULE 9:
Every strategy MUST contain an experiment design.

The experiment should describe a test/control or comparable evaluation
rather than simply "monitor results."

RULE 10:
Do not claim that the intervention WILL reduce churn.

Use:

"could"
"may"
"hypothesis"
"test whether"

RULE 11:
Keep the recommendations commercially realistic.

The output should sound like something a professional Data Analyst
could present to a retention or marketing team.

RULE 12:
Do not repeat the same intervention three times.

The three strategies should address the three different target
segments with meaningfully different interventions.

============================================================
FINAL SELF-CHECK
============================================================

Before answering, check:

- Exactly 3 strategies?
- Correct priorities 1, 2, 3?
- Correct target segments?
- Exact supplied percentages only?
- No invented statistics?
- No causal claims?
- Four actions per strategy?
- Experiment design included?
- Hypothesis clearly labeled?
- No arbitrary numeric targets?
- Three meaningfully different interventions?
- Recommendations are actionable rather than summaries?

If anything fails, rewrite it before producing the final answer.

Return ONLY the three strategies.
"""


    return prompt


if __name__ == "__main__":

    prompt = build_recommendation_prompt(evidence)

    print("\nGenerating retention strategies with local Llama...\n")

    response = chat(
        model="llama3.2:3b",
        messages=[
            {
                "role": "user",
                "content": prompt
            }
        ]
    )

    recommendations = response.message.content

    print("=" * 70)
    print("GENAI RETENTION STRATEGIES")
    print("=" * 70)
    print()
    print(recommendations)

    project_root = Path(__file__).resolve().parent.parent

    output_file = project_root / "genai" / "retention_strategies.md"

    output_file.write_text(
        recommendations,
        encoding="utf-8"
    )

    print()
    print(f"Saved to: {output_file}")