module ArkoudaSparseMatrixCompat {
    use CompressedSparseLayout;
    import SparseMatrix.SpsMatUtil.Layout;
    use BlockDist;

    proc getSparseDom(param layout: Layout) {
        select layout {
            when Layout.CSR do return new csrLayout();
            when Layout.CSC do return new cscLayout();
        }
    }

    proc getParSafeSparseDom(param layout: Layout) {
        select layout {
            when Layout.CSR do return new csrLayout(parSafe=true);
            when Layout.CSC do return new cscLayout(parSafe=true);
        }
    }

   // see: https://github.com/chapel-lang/chapel/issues/26209
    proc getDenseDom(dom, localeGrid, param layout: Layout) {
        if layout == Layout.CSR {
            return dom dmapped new blockDist(boundingBox=dom,
                                             targetLocales=localeGrid,
                                             sparseLayoutType=csrLayout);
        } else {
            return dom dmapped new blockDist(boundingBox=dom,
                                             targetLocales=localeGrid,
                                             sparseLayoutType=cscLayout);
        }
    }

    proc getParSafeDenseDom(dom, localeGrid, param layout: Layout) {
        if layout == Layout.CSR {
            return dom dmapped new blockDist(boundingBox=dom,
                                             targetLocales=localeGrid,
                                             sparseLayoutType=csrLayout(parSafe=true));
        } else {
            return dom dmapped new blockDist(boundingBox=dom,
                                             targetLocales=localeGrid,
                                             sparseLayoutType=cscLayout(parSafe=true));
        }
    }
}
