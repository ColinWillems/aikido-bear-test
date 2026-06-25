import en from "./translations/en.json";

type Translations = typeof en;

const translationsMap: Record<string, Translations> = {
  en,
};

const DEFAULT_LOCALE = "en";

function getBrowserLocale(): string {
  if (typeof navigator === "undefined") {
    return DEFAULT_LOCALE;
  }

  const browserLang = navigator.language || DEFAULT_LOCALE;
  const primaryLang = browserLang.split("-")[0];

  if (translationsMap[browserLang]) {
    return browserLang;
  }

  if (translationsMap[primaryLang]) {
    return primaryLang;
  }

  return DEFAULT_LOCALE;
}

export function getLocale(): string {
  return getBrowserLocale();
}

export function getTranslations(): Translations {
  const locale = getLocale();
  return translationsMap[locale] ?? translationsMap[DEFAULT_LOCALE];
}
