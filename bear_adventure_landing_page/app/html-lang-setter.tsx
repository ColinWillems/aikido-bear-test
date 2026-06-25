"use client";

import { useEffect } from "react";
import { getLocale } from "./i18n";

export function HtmlLangSetter() {
  useEffect(() => {
    const locale = getLocale();
    document.documentElement.lang = locale;
  }, []);

  return null;
}
