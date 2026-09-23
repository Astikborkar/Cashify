from app.schemas.agents import (
    DiagnosticsEvaluationRequest,
    DiagnosticsEvaluationResponse,
)


class DiagnosticsAgent:
    """Agent 2: Diagnostics QC Agent (Hardware QC Evaluator).
    Evaluates automated hardware telemetry, detects sensor spoofing,
    and calculates 0-100 Device Health Score.
    """

    def evaluate_telemetry(self, req: DiagnosticsEvaluationRequest) -> DiagnosticsEvaluationResponse:
        total_tests = len(req.tests) if req.tests else 1
        passed_count = sum(1 for t in req.tests if t.passed)
        failed_count = total_tests - passed_count

        flagged_defects = []
        spoofing_detected = False

        for t in req.tests:
            if not t.passed:
                flagged_defects.append(t.test_name)

            # Detect sensor spoofing (e.g. constant velocity, fake touch events)
            if t.test_id == "gyroscope" and t.sensor_telemetry:
                angular_velocity = t.sensor_telemetry.get("delta_rad_s", 0)
                if angular_velocity == 0:  # Flatline or simulated
                    spoofing_detected = True

            if t.test_id == "touch_screen" and t.sensor_telemetry:
                coverage = t.sensor_telemetry.get("matrix_coverage", 1.0)
                if coverage < 0.95:
                    if "Dead Touch Zones" not in flagged_defects:
                        flagged_defects.append("Dead Touch Zones")

        # Health score calculation
        ratio = passed_count / total_tests
        health_score = int(ratio * 100)

        if spoofing_detected:
            health_score = max(10, health_score - 30)

        if health_score >= 85:
            grade = "EXCELLENT"
        elif health_score >= 65:
            grade = "GOOD"
        else:
            grade = "DEFECTIVE"

        return DiagnosticsEvaluationResponse(
            overall_health_score=health_score,
            hardware_grade=grade,
            tests_passed=passed_count,
            tests_failed=failed_count,
            spoofing_detected=spoofing_detected,
            flagged_defects=flagged_defects,
        )


diagnostics_agent = DiagnosticsAgent()
