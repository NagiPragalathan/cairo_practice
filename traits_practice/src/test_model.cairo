pub trait Summary {
    fn summarize(self: @NewsArticle) -> ByteArray;
}
