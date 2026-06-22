from sklearn.feature_extraction.text import HashingVectorizer

from app.core.config import EMBEDDING_DIMENSIONS
from app.services.text_normalizer import normalize_text

_vectorizer = HashingVectorizer(
    n_features=EMBEDDING_DIMENSIONS,
    alternate_sign=False,
    norm="l2",
)


def generate_embedding(text: str) -> list[float]:
    vector = _vectorizer.transform([normalize_text(text)]).toarray()[0]
    return [float(value) for value in vector]
