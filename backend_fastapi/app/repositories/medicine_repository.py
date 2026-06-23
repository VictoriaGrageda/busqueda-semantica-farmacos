from sqlalchemy.orm import Session

from app.models.medicine import Medicine


class MedicineRepository:
    def __init__(self, db: Session) -> None:
        self._db = db

    def count(self) -> int:
        return self._db.query(Medicine).count()

    def delete_all(self) -> int:
        deleted = self._db.query(Medicine).delete()
        self._db.flush()
        return deleted

    def list_all(self) -> list[dict]:
        medicines = self._db.query(Medicine).order_by(Medicine.medicamento.asc()).all()
        return [medicine.to_dict(score=0) for medicine in medicines]

    def add(self, medicine_data: dict, document: str, embedding: list[float]) -> None:
        self._db.add(
            Medicine(
                medicamento=medicine_data["medicamento"],
                principio_activo=medicine_data["principio_activo"],
                grupo_farmacologico=medicine_data["grupo_farmacologico"],
                mecanismo_accion=medicine_data.get("mecanismo_accion"),
                indicaciones=medicine_data["indicaciones"],
                contraindicaciones=medicine_data["contraindicaciones"],
                reacciones_adversas=medicine_data["reacciones_adversas"],
                interacciones=medicine_data.get("interacciones", []),
                via_administracion=medicine_data["via_administracion"],
                forma_farmaceutica=medicine_data["forma_farmaceutica"],
                fuentes=medicine_data.get("fuentes", []),
                documento_busqueda=document,
                embedding=embedding,
            )
        )

    def search_by_embedding(self, embedding: list[float], limit: int = 10) -> list[dict]:
        distance = Medicine.embedding.cosine_distance(embedding)
        rows = (
            self._db.query(Medicine, (1 - distance).label("score"))
            .order_by(distance)
            .limit(limit)
            .all()
        )
        return [medicine.to_dict(score=round(float(score), 4)) for medicine, score in rows]
