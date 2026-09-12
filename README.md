# Customer Churn Analytics & GenAI

An end-to-end customer churn analytics project using **Python, SQL Server, Power BI, and GenAI** to identify high-risk customer segments and generate actionable, testable retention strategies.

## Business Problem

Customer churn directly impacts recurring revenue and customer retention. This project analyzes telecom customer data to identify patterns associated with churn and translate those findings into business-focused retention strategies.

## Dataset

- **7,043 customers**
- **21 customer attributes**
- Target variable: **Churn**

## Tools & Technologies

- **Python / Pandas** — Data cleaning, analysis & EDA
- **SQL Server** — Business analysis & customer segmentation
- **Power BI** — Interactive dashboard & visualization
- **Ollama + Llama 3.2** — Local GenAI strategy generation
- **Git & GitHub** — Version control & documentation

## Project Workflow

```text
Customer Data
     ↓
Python / Pandas
Cleaning & Exploratory Analysis
     ↓
SQL Server
Business Analysis & Segmentation
     ↓
Power BI
Interactive Churn Dashboard
     ↓
Validated Churn Evidence
     ↓
Llama 3.2 via Ollama
GenAI Retention Strategies
```

## Key Findings

- Overall churn rate: **26.54%**
- Month-to-month customers: **42.71% churn**
- Month-to-month + Fiber optic: **54.61% churn**
- Month-to-month + Electronic check: **53.73% churn**
- Customers with 0–12 months tenure: **47.44% churn**
- Electronic check customers: **45.29% churn**
- Customers without Online Security: **41.77% churn**
- Customers without Tech Support: **41.64% churn**

Customers exhibiting more observed high-risk characteristics also showed progressively higher observed churn, ranging from **1.92%** with zero characteristics to **74.45%** with all six.

> These findings represent observed associations in the dataset and should not be interpreted as causal relationships.

## Power BI Dashboard

### Customer Churn Analysis
- Executive KPIs
- Churn by contract
- Churn by payment method
- Churn by tenure
- Contract + Internet Service segmentation
- Interactive slicers

### Churn Drivers & Customer Risk
- High-risk segment KPIs
- Online Security analysis
- Tech Support analysis
- Risk-factor segmentation
- Interactive cross-filtering

## GenAI Component

The GenAI layer uses **Llama 3.2 locally through Ollama** to convert validated churn analysis into practical retention strategies.

The model generates:

- Prioritized target segments
- Retention interventions
- Specific business actions
- Testable hypotheses
- Experiment designs
- Success metrics
- Assumptions and limitations

Analytical evidence is supplied to the model with explicit guardrails to prevent invented statistics and unsupported causal claims.

### GenAI Approach

```text
Validated Analytics
       ↓
Structured Evidence
       ↓
Prompt + Guardrails
       ↓
Local LLM
       ↓
Retention Strategy
       ↓
Experiment & Measurement
```

## Repository Structure

```text
customer-churn-ai/
│
├── data/
│   └── WA_Fn-UseC_-Telco-Customer-Churn.csv
│
├── notebooks/
│   └── churn_analysis.ipynb
│
├── sql/
│   └── churn_analysis.sql
│
├── powerbi/
│   └── Churn_analysis.pbix
│
├── src/
│   ├── churn_evidence.py
│   └── genai_recommendations.py
│
├── genai/
│   ├── recommendation_prompt.md
│   └── retention_strategies.md
│
├── .gitignore
└── README.md
```

## Key Takeaway

This project demonstrates an end-to-end analytics workflow:

**Analyze → Segment → Visualize → Generate Strategies → Test**

It combines traditional data analytics with a locally hosted GenAI layer to move from **identifying churn patterns to proposing measurable retention interventions**.
