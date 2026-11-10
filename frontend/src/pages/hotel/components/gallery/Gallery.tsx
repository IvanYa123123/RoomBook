import React from 'react';
import styles from './Gallery.module.css';

interface GalleryProps {
  images: string[];
  mainImage: string;
  alt: string;
  onSelect: (image: string) => void;
}

/** Большое фото + колонка миниатюр; клик по миниатюре меняет главное фото */
export const Gallery: React.FC<GalleryProps> = ({ images, mainImage, alt, onSelect }) => {
  const thumbs = images.filter((img) => img !== mainImage).slice(0, 4);

  return (
    <div className={styles.gallery}>
      <div className={styles.main}>
        <img src={mainImage} alt={alt} className={styles.mainImage} />
      </div>

      <div className={styles.thumbs}>
        {thumbs.map((img, i) => (
          <button
            key={img + i}
            type="button"
            className={styles.thumb}
            onClick={() => onSelect(img)}
            aria-label={`Показать фото ${i + 2}`}
          >
            <img src={img} alt="" loading="lazy" />
          </button>
        ))}
      </div>
    </div>
  );
};

export default Gallery;
