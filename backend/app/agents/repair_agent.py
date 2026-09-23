from app.schemas.agents import (
    RepairCostBreakdownItem,
    RepairEstimateRequest,
    RepairEstimateResponse,
)


class RepairCostAgent:
    """Agent 4: Repair Cost Agent (Smart Parts & Labor Estimator).
    Calculates parts + technician labor, applies 15% combo bundle discount
    when multiple repairs are requested, and outputs warranty periods.
    """

    PARTS_CATALOG = {
        "screen_glass": {"name": "Touch Screen Glass Replacement", "part": 1499.0, "labor": 500.0, "time": 30},
        "oled_display": {"name": "Full OLED Digitizer Assembly", "part": 4999.0, "labor": 700.0, "time": 45},
        "battery": {"name": "OEM Certified Battery Replacement", "part": 1499.0, "labor": 400.0, "time": 25},
        "charging_port": {"name": "USB-C / Lightning Port Replacement", "part": 899.0, "labor": 350.0, "time": 20},
        "camera_lens": {"name": "Rear Camera Sapphire Glass Lens", "part": 699.0, "labor": 300.0, "time": 20},
        "earpiece": {"name": "Receiver & Loudspeaker Mesh", "part": 599.0, "labor": 300.0, "time": 20},
    }

    def estimate_repair(self, req: RepairEstimateRequest) -> RepairEstimateResponse:
        items = []
        subtotal = 0.0
        total_time = 0
        total_labor = 0.0

        for issue_key in req.issues:
            info = self.PARTS_CATALOG.get(issue_key, {
                "name": issue_key.replace("_", " ").title(),
                "part": 1200.0,
                "labor": 400.0,
                "time": 30
            })
            part_cost = info["part"]
            labor_cost = info["labor"]
            total_labor += labor_cost
            subtotal += (part_cost + labor_cost)
            total_time += info["time"]

            items.append(RepairCostBreakdownItem(
                issue_name=info["name"],
                part_cost=part_cost,
                labor_cost=labor_cost,
                warranty_months=6,
            ))

        # 15% combo discount on labor if more than 1 issue is reported
        combo_discount = 0.0
        if len(items) > 1:
            combo_discount = round(total_labor * 0.15, 2)

        final_total = max(499.0, round(subtotal - combo_discount, 2))

        return RepairEstimateResponse(
            device=f"{req.brand} {req.model}",
            items=items,
            subtotal=round(subtotal, 2),
            combo_discount=combo_discount,
            final_total=final_total,
            estimated_time_minutes=total_time,
            parts_guarantee="OEM Grade Certified 6-Month Doorstep Warranty",
        )


repair_cost_agent = RepairCostAgent()
