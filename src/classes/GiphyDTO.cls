/**
 * @description DTO object used when deserialize JSON response from Giphy API
 */
public with sharing class GiphyDTO {
    // There could be other fields
    // But, I leave here only those fields which I definitely need

    public DataObject data;

    public class DataObject {
        public String gifId;
    }
}