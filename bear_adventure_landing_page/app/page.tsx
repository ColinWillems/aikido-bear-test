"use client";

import { Suspense, useEffect, useState } from "react";
import { useSearchParams } from "next/navigation";
import styles from "./page.module.css";
import { getTranslations } from "./i18n";
import {
  CountrySelectorDialog,
  CountrySelection,
  CountryCode,
  CountryOption,
} from "./country-selector-dialog";

type Platform = "android" | "ios" | "unknown";

function detectPlatform(): Platform {
  if (typeof navigator === "undefined") return "unknown";
  const ua = navigator.userAgent.toLowerCase();
  if (/android/.test(ua)) return "android";
  if (/iphone|ipad|ipod/.test(ua)) return "ios";
  return "unknown";
}

function copyToPasteboard(value: string): void {
  if (navigator.clipboard) {
    navigator.clipboard.writeText(value).catch(() => {
      fallbackCopy(value);
    });
  } else {
    fallbackCopy(value);
  }
}

function fallbackCopy(value: string): void {
  const textarea = document.createElement("textarea");
  textarea.value = value;
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.focus();
  textarea.select();
  document.execCommand("copy");
  document.body.removeChild(textarea);
}

function buildPlayStoreUrl(cardPath: string): string {
  const packageName = "com.bearsnacks.bearadventure";
  const referrer = encodeURIComponent(cardPath);
  return `https://play.google.com/store/apps/details?id=${packageName}&referrer=${referrer}`;
}

function buildAppStoreUrl(): string {
  return "https://testflight.apple.com/v1/invite/d0e17312a04f482a97108f437e22641312e9661318d041afb0f98cb4b6a2c07e19375a6a2?ct=24NC63RDSP&advp=10000&platform=ios";
}

const COUNTRY_ORDER: CountryCode[] = ["uk", "us", "ca", "ir", "nl", "cz"];

function HomeContent() {
  const searchParams = useSearchParams();
  const [cardPath, setCardPath] = useState<string | null>(null);
  const [platform, setPlatform] = useState<Platform>("unknown");
  const [countrySelected, setCountrySelected] = useState(false);
  const t = getTranslations();

  const countries: CountryOption[] = COUNTRY_ORDER.map((code) => ({
    code,
    label: t.countryDialog.countries[code],
  }));

  useEffect(() => {
    const path = searchParams.get("path");

    if (!path) {
      window.location.href = t.redirectUrl;
      return;
    }

    setPlatform(detectPlatform());
    setCardPath(path);
  }, [searchParams]);

  const handleCountrySelect = (selection: CountrySelection) => {
    if (selection === "uk" || selection === 'us') {
      if (platform === "ios" && cardPath) {
        copyToPasteboard(cardPath);
      }
      setCountrySelected(true);
      return;
    }

    if (selection === "other") {
      window.location.href = t.redirectUrl;
      return;
    }

    const countryRedirectUrls = t.countryDialog.redirectUrls as Record<string, string>;
    window.location.href = countryRedirectUrls[selection] ?? t.redirectUrl;
  };

  if (!cardPath) {
    return null;
  }

  const playStoreUrl = buildPlayStoreUrl(cardPath);
  const appStoreUrl = buildAppStoreUrl();

  return (
    <>
      <a href="#main-content" className={styles.skipLink}>
        Skip to main content
      </a>

      <main id="main-content" className={styles.container}>
        <div className={styles.layout}>
          <div className={styles.headerImageWrapper}>
            <img
              src="/images/lp-header.png"
              alt={t.headerImageAlt}
              className={styles.headerImage}
            />
          </div>

          <div className={styles.contentWrapper}>
            <h1 className={styles.heading}>
              <span className={styles.headingPrefix}>{t.headingPrefix} </span>
              <span className={styles.headingHighlight}>{t.headingHighlight}</span>
            </h1>

            <p className={styles.description}>{t.downloadPrompt}</p>

            <img
              src="/images/lp-logo.png"
              alt=""
              role="presentation"
              className={styles.logo}
            />

            <nav aria-label="Download the app" className={styles.badges}>
              <a
                href={appStoreUrl}
                target="_blank"
                rel="noopener noreferrer"
                className={styles.badgeLink}
              >
                <img
                  src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/en-us?size=250x83&amp;releaseDate=1311120000"
                  alt={t.appStoreBadgeAlt}
                  className={styles.badge}
                />
              </a>
              <a
                href={playStoreUrl}
                target="_blank"
                rel="noopener noreferrer"
                className={styles.badgeLink}
              >
                <img
                  src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png"
                  alt={t.googlePlayBadgeAlt}
                  className={styles.badgeGoogle}
                />
              </a>
            </nav>
          </div>
        </div>
      </main>

      <CountrySelectorDialog
        open={!countrySelected}
        title={t.countryDialog.title}
        countries={countries}
        flagAltTemplate={t.countryDialog.flagAlt}
        otherCountriesLabel={t.countryDialog.otherCountries}
        otherCountriesDescription={t.countryDialog.otherCountriesDescription}
        onSelect={handleCountrySelect}
      />
    </>
  );
}

export default function Home() {
  return (
    <Suspense fallback={null}>
      <HomeContent />
    </Suspense>
  );
}
