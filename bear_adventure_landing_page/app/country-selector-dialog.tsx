"use client";

import { useEffect, useRef } from "react";
import styles from "./country-selector-dialog.module.css";

export type CountryCode = "uk" | "us" | "ca" | "ir" | "nl" | "cz";
export type CountrySelection = CountryCode | "other";

export interface CountryOption {
  code: CountryCode;
  label: string;
}

interface CountrySelectorDialogProps {
  open: boolean;
  title: string;
  countries: CountryOption[];
  flagAltTemplate: string;
  otherCountriesLabel: string;
  otherCountriesDescription: string;
  onSelect: (code: CountrySelection) => void;
}

export function CountrySelectorDialog({
  open,
  title,
  countries,
  flagAltTemplate,
  otherCountriesLabel,
  otherCountriesDescription,
  onSelect,
}: CountrySelectorDialogProps) {
  const dialogRef = useRef<HTMLDialogElement>(null);
  const firstButtonRef = useRef<HTMLButtonElement>(null);

  useEffect(() => {
    const dialog = dialogRef.current;
    if (!dialog) return;

    if (open && !dialog.open) {
      // showModal provides built-in focus trap, ESC handling, inert background,
      // and a ::backdrop pseudo-element that dims the page beneath.
      dialog.showModal();
      requestAnimationFrame(() => {
        firstButtonRef.current?.focus();
      });
    } else if (!open && dialog.open) {
      dialog.close();
    }
  }, [open]);

  // Prevent dismissal via ESC: a country must be chosen.
  const handleCancel = (event: React.SyntheticEvent<HTMLDialogElement>) => {
    event.preventDefault();
  };

  return (
    <dialog
      ref={dialogRef}
      className={styles.dialog}
      aria-labelledby="country-dialog-title"
      aria-describedby={otherCountriesDescription ? "country-dialog-description" : undefined}
      aria-modal="true"
      onCancel={handleCancel}
    >
      <div className={styles.content} role="document">
        <h2 id="country-dialog-title" className={styles.title}>
          {title}
        </h2>

        <ul className={styles.list} role="list" aria-label={title}>
          {countries.map((country, index) => (
            <li key={country.code} className={styles.listItem}>
              <button
                ref={index === 0 ? firstButtonRef : undefined}
                type="button"
                className={styles.countryButton}
                onClick={() => onSelect(country.code)}
                aria-label={country.label}
              >
                <img
                  src={`/images/flags/flag-${country.code}.png`}
                  alt=""
                  aria-hidden="true"
                  className={styles.flag}
                />
                <span className={styles.countryLabel}>{country.label}</span>
              </button>
            </li>
          ))}
        </ul>

        <div className={styles.otherSection}>
          <button
            type="button"
            className={styles.otherButton}
            onClick={() => onSelect("other")}
          >
            {otherCountriesLabel}
          </button>
        </div>

        {otherCountriesDescription && (
          <p id="country-dialog-description" className={styles.description}>
            {otherCountriesDescription}
          </p>
        )}
      </div>
    </dialog>
  );
}
