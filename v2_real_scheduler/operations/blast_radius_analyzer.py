import csv, json, sys
from pathlib import Path
from collections import defaultdict

base = Path("v2_real_scheduler/data/synthetic")
ops = Path("v2_real_scheduler/operations")
reports = Path("v2_real_scheduler/reports")
reports.mkdir(parents=True, exist_ok=True)

sections = list(csv.DictReader(open(base/"sections_overconstrained.csv")))
enrollments = list(csv.DictReader(open(base/"enrollments_5810_students.csv")))

section_students = defaultdict(set)
for e in enrollments:
    section_students[e["section_id"]].add(e["student_id"])

section_by_id = {s["section_id"]: s for s in sections}

def analyze(node_id):
    affected_sections = []

    if node_id.startswith("T"):
        affected_sections = [s for s in sections if s["teacher_id"] == node_id]
        node_type = "teacher"
    elif node_id.startswith("R"):
        affected_sections = [s for s in sections if s["room_id"] == node_id]
        node_type = "room"
    elif node_id.startswith("SEC"):
        affected_sections = [section_by_id[node_id]] if node_id in section_by_id else []
        node_type = "section"
    else:
        node_type = "unknown"

    teachers = {s["teacher_id"] for s in affected_sections}
    rooms = {s["room_id"] for s in affected_sections}
    students = set()

    for s in affected_sections:
        students.update(section_students.get(s["section_id"], set()))

    disruption_hours = (
        len(affected_sections) * 1.5 +
        len(students) * 0.05 +
        len(rooms) * 0.75
    )

    disruption_cost = disruption_hours * 85

    return {
        "node_id": node_id,
        "node_type": node_type,
        "affected_sections": len(affected_sections),
        "affected_teachers": len(teachers),
        "affected_rooms": len(rooms),
        "affected_students": len(students),
        "estimated_disruption_hours": round(disruption_hours, 2),
        "estimated_disruption_cost": round(disruption_cost, 2),
        "sections": [
            {
                "section_id": s["section_id"],
                "course": s["course"],
                "teacher_id": s["teacher_id"],
                "room_id": s["room_id"],
                "period": s["period"],
                "students": len(section_students.get(s["section_id"], set()))
            }
            for s in affected_sections
        ],
        "source_truth": "Synthetic dependency analysis. Estimates are explicit model assumptions."
    }

node = sys.argv[1] if len(sys.argv) > 1 else "T0161"
result = analyze(node)

outfile = reports / f"blast_radius_{node}.json"
outfile.write_text(json.dumps(result, indent=2))

print("")
print("BLAST RADIUS ANALYSIS")
print("=====================")
print("Node:", result["node_id"])
print("Type:", result["node_type"])
print("Sections:", result["affected_sections"])
print("Teachers:", result["affected_teachers"])
print("Rooms:", result["affected_rooms"])
print("Students:", result["affected_students"])
print("Hours:", result["estimated_disruption_hours"])
print("Cost: $", f"{result['estimated_disruption_cost']:,.2f}")
print("")
print("Wrote:")
print(outfile)
