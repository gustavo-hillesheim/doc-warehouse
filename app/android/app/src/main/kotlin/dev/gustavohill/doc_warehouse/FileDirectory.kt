package dev.gustavohill.doc_warehouse

import android.content.Context
import android.net.Uri
import android.webkit.MimeTypeMap
import java.io.File

object FileDirectory {

    fun createTempCopy(context: Context, uri: Uri): String? {
        if (uri.path == null) {
            return null
        }
        val contentResolver = context.contentResolver
        val mimeType = contentResolver.getType(uri)
        val extension = MimeTypeMap.getSingleton().getExtensionFromMimeType(mimeType)

        val tempFile = File.createTempFile(uri.lastPathSegment ?: "tempFile", ".$extension", context.cacheDir)
        tempFile.deleteOnExit()
        val input = contentResolver.openInputStream(uri) ?: return null
        val output = tempFile.outputStream()
        input.copyTo(output)
        input.close()
        output.close()
        return tempFile.absolutePath
    }
}