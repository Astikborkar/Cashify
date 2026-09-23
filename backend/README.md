# Cashify Clone — FastAPI Backend & AI Multi-Agent Swarm

Enterprise-grade backend powering the Cashify Clone platform built with **FastAPI 0.115+**, **SQLAlchemy 2.0 Async**, **PostgreSQL 16**, **Redis 7**, and an **Autonomous 7-Agent AI Swarm**.

---

## 1. AI Multi-Agent Architecture
The platform coordinates 7 specialized AI agents orchestrated by a centralized **Supervisor & Router Agent**:
- **Agent 1: Pricing AI Agent** — Valuation engine computing age depreciation, cosmetic penalties, accessory bonuses, and market elasticity.
- **Agent 2: Diagnostics QC Agent** — Sensor spoofing detection and 0–100 Device Health Score.
- **Agent 3: Fraud Detection Shield** — GSMA blacklist lookup, duplicate IMEI tracking, mock GPS filter.
- **Agent 4: Repair Cost Estimator** — OEM parts and labor calculation with 15% combo bundle discounts.
- **Agent 5: Recommendation Agent** — Natural language refurbished phone matching with trade-in upgrade calculations.
- **Agent 6: Customer Support Chatbot** — Order status tracking, pickup rescheduling, warranty triage, and human escalation.
- **Agent 7: Omnichannel Notification Agent** — Push, WhatsApp, and SMS dispatch rules.

---

## 2. Quickstart & Local Development

### Prerequisites
- Python 3.12+
- PostgreSQL 16 & Redis 7 (or Docker)

### Setup & Run
```bash
# 1. Create and activate virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 2. Install dependencies
pip install -r requirements.txt

# 3. Configure environment
cp .env.example .env

# 4. Start the server
python run_server.py
```
API is accessible at:
- **Swagger Docs:** `http://localhost:8000/api/v1/docs`
- **ReDoc:** `http://localhost:8000/api/v1/redoc`
- **Health Check:** `http://localhost:8000/health`

---

## 3. Docker Deployment
```bash
# Launch entire stack (FastAPI, PostgreSQL 16, Redis 7, Celery Worker)
docker-compose up -d --build

# View logs
docker-compose logs -f api
```

---

## 4. Running Agent Unit Tests
```bash
pytest tests/test_agents.py -v
```
