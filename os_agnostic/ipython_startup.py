def get_df():
    """
    Utility function for quickly getting an Apache Spark DataFrame for
    testing, introspection, etc.

    This will obviously only work when running pyspark.

    :returns: a pyspark data frame with columns x, y, x.
    :rtype: pyspark.sql.dataframe.DataFrame
    """
    from pyspark.sql import Row
    return sc.parallelize([Row(1, 'a', 2.0), Row(3, 'b', 4.2)])\
             .toDF(['x', 'y', 'z'])
