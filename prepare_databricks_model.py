import csv
from pathlib import Path


ROOT = Path(__file__).resolve().parent
DATA = ROOT / "data"


def keyed_rows(path: Path, key: str):
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return {row[key]: row for row in csv.DictReader(handle)}


consultants = keyed_rows(DATA / "Dim_Consultant.csv", "consultant_id")
verticals = keyed_rows(DATA / "Dim_Vertical.csv", "vertical_id")
vendors = keyed_rows(DATA / "Dim_Vendor.csv", "vendor_id")

source = DATA / "Fact_RequestCapacityEvents.csv"
target = DATA / "Fact_RequestCapacityEvents_Enriched.csv"

with source.open("r", encoding="utf-8-sig", newline="") as src:
    reader = csv.DictReader(src)
    fields = list(reader.fieldnames or []) + [
        "consultant_name",
        "vertical_name",
        "vendor_name",
        "vendor_type",
        "vendor_sla_target_hours",
    ]
    with target.open("w", encoding="utf-8", newline="") as dst:
        writer = csv.DictWriter(dst, fieldnames=fields)
        writer.writeheader()
        for row in reader:
            consultant = consultants.get(row["consultant_id"], {})
            vertical = verticals.get(row["vertical_id"], {})
            vendor = vendors.get(row["vendor_id"], {})
            row.update(
                consultant_name=consultant.get("consultant_name", "Unknown"),
                vertical_name=vertical.get("vertical_name", "Unknown"),
                vendor_name=vendor.get("vendor_name", "Unknown"),
                vendor_type=vendor.get("vendor_type", "Unknown"),
                vendor_sla_target_hours=vendor.get("sla_target_hours", ""),
            )
            writer.writerow(row)

print(target)
